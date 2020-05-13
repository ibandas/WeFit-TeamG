//
//  WorkoutLogTVC.swift
//  WeFit
//
//  Created by Irinel Bandas on 4/25/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.


import UIKit
import Firebase
import FBSDKLoginKit

class WorkoutLog: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var exercises: [Exercise] = []
    var sectionsCount: Int = 0
    let uid = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loadWorkouts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPossibleExercises" {
            let destination = segue.destination as! AddExercisesVC
            for exercise in self.exercises {
                destination.already_chosen_exercises.append(exercise.title)
            }
            print(destination.already_chosen_exercises)
        }
    }
    
    func loadWorkouts() {
        // let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())

        let ref = Firestore.firestore().collection("users/\(self.uid)/workouts").whereField("created_at", isDateInToday: Date()).order(by: "created_at")

        ref.getDocuments(completion: {(snapshot, error) in
            if error != nil {
                print("Error")
            }
            else {
                var workoutDict = [String: [Set]]()
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let id = document.documentID
                    let data = document.data()
                    let created_at_ts = data["created_at"] as? Timestamp
                    let created_at = created_at_ts?.dateValue()
                    let exercise_title = data["title"] as? String ?? ""
                    let weight = data["weight"] as? Int
                    let reps = data["reps"] as? Int
                    let completion = data["completion"] as? Bool
                    var exercise_sets = workoutDict[exercise_title]
                    let set = Set(set_id: id, weight: weight!, reps: reps!, created_at: created_at!, completion: completion!)
                    if exercise_sets == nil {
                        workoutDict[exercise_title] = [set]
                    }
                    else {
                        exercise_sets?.append(set)
                        workoutDict[exercise_title] = exercise_sets
                    }
                }
                for (key, value) in workoutDict {
                    self.exercises.append(Exercise(title: key, sets: value))
                }
            }
            self.exercises.sort(by: {$0.sets[0].created_at < $1.sets[0].created_at})
            self.setSectionsCount()
            self.tableView.reloadData()
        })
    }
    
    // Adds set to exercise data and row to the VC
    func addSet(indexPath: IndexPath) {
        let exercise_title = exercises[indexPath.section].title
        let created_at = Date()
        let weight = 0
        let reps = 0
        let set_id = Firestore.firestore().collection("users/\(self.uid)/workouts").addDocument(data: [
            "title": exercise_title,
            "weight": weight,
            "reps": reps,
            "created_at": created_at,
            "completion": false])
        let set = Set(set_id: set_id.documentID, weight: 0, reps: 0, created_at: created_at, completion: false)
        exercises[indexPath.section].sets.append(set)

        let indexPath = IndexPath(row: exercises[indexPath.section].sets.count, section: indexPath.section)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func updateExerciseinFirestore(set_id: String, weight: Int, reps: Int) {
        let ref = Firestore.firestore().collection("users/\(uid)/workouts").document(set_id)
        ref.updateData([
            "weight": weight,
            "reps": reps
        ]) { err in
            if let err = err {
                print(err)
            } else {
                print("Success updating set")
            }
        }
    }
    
    
    // Updates an Exercises's Set's Weight value
    func updateWeight(indexPath: IndexPath, cell: SetCell) {
        if let weightNum = Int(cell.WeightEntry.text!) {
            exercises[indexPath.section].sets[indexPath.row - 1].weight = weightNum
            let setTemp: Set = exercises[indexPath.section].sets[indexPath.row - 1]
            self.updateExerciseinFirestore(set_id: setTemp.set_id,
                                           weight: weightNum,
                                           reps: setTemp.reps)
        }
    }
    
    // Updates an Exercise's Set's Reps value
    func updateReps(indexPath: IndexPath, cell: SetCell) {
        if let repsNum = Int(cell.RepEntry.text!) {
            exercises[indexPath.section].sets[indexPath.row - 1].reps = repsNum
            let setTemp: Set = exercises[indexPath.section].sets[indexPath.row - 1]
            self.updateExerciseinFirestore(set_id: setTemp.set_id,
                                           weight: setTemp.weight,
                                           reps: repsNum)
        }
    }
    
    // Deletes an Exercise
    func deleteExercise(indexPath: IndexPath) {
        deleteEntireExercise(indexPath: indexPath)
    }
    
    func setSectionsCount() {
        sectionsCount = exercises.count + 1
    }
    
    
    @IBAction func unwindFromAddExercisesVC(_ sender: UIStoryboardSegue) {
        if sender.source is AddExercisesVC {
            if let senderVC = sender.source as? AddExercisesVC {
                let created_at = Date()
                for exercise in senderVC.selectedExercises {
                    let exercise_doc = Firestore.firestore().collection("users/\(self.uid)/workouts").addDocument(data: [
                        "created_at": created_at,
                        "title": exercise,
                        "weight": 0,
                        "reps": 0,
                        "completion": false])
                    self.exercises.append(Exercise(title: exercise, sets: [Set(set_id: exercise_doc.documentID, weight: 0, reps: 0, created_at: created_at, completion: false)]))
                }
            }
            setSectionsCount()
            tableView.reloadData()
        }
    }
    
}

// Extension of VC for AddSetCell that allows adding another set for an exercise
extension WorkoutLog: AddSetCellDelegate {
    func didTapAddSetButton(cell: AddSetCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        addSet(indexPath: indexPath!)
    }
}

extension WorkoutLog: AddExerciseCellDelegate {
    func didTapExercisesButton(cell: AddExerciseCell) {
        let destination = AddExercisesVC()
        for exercise in self.exercises {
            destination.already_chosen_exercises.append(exercise.title)
        }
        print(destination.already_chosen_exercises)
    }
}

// Extension of VC for SetCell that allows updates of weight/reps
extension WorkoutLog: SetCellDelegate {
    func updateWeight(cell: SetCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            updateWeight(indexPath: indexPath, cell: cell)
        } else {
            print("ERROR")
        }
    }
    func updateReps(cell: SetCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            updateReps(indexPath: indexPath, cell: cell)
        } else {
            print("ERROR")
        }
    }
    
    func updateChallenge(cell: SetCell, completion: @escaping () -> ()) {
        let indexPath = self.tableView.indexPath(for: cell)
        let exercise_title = exercises[indexPath!.section].title
        let challenge_ref = Firestore.firestore().collection("challenges").whereField("active", isEqualTo: true).whereField("members", arrayContains: self.uid).whereField("exercise", isEqualTo: exercise_title)
        let field_path = FieldPath(["scores", self.uid, "points"])
        challenge_ref.getDocuments(completion: {(snapshot, error) in
            if error != nil {
                print("Error")
            } else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let points = Int64(cell.RepEntry.text!)!
                    if !cell.completed {
                        document.reference.updateData([field_path: FieldValue.increment(points)])
                        print("Added 50 to challenge points")
                    } else {
                        let points = (points * -1)
                        document.reference.updateData([field_path: FieldValue.increment(points)])
                        print("Subtracting 50 to challenge points")
                    }
                }
                completion()
            }
        })
    }
    
    func updateCompletion(cell: SetCell) {
        let indexPath: IndexPath = self.tableView.indexPath(for: cell)!
        let set_id = exercises[indexPath.section].sets[indexPath.row-1].set_id
        let set_doc = Firestore.firestore().collection("users/\(self.uid)/workouts").document(set_id)
        set_doc.updateData(["completion": cell.completed])
    }
}

// Extension of VC for ExerciseCell that allows deletion of Exercise section
extension WorkoutLog: ExerciseCellDelegate {
    func didTapDeleteExerciseButton(cell: ExerciseCell) {
        let indexPath = self.tableView.indexPath(for: cell)!
        deleteExercise(indexPath: indexPath)
    }
}

extension WorkoutLog:  UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }
    
    // Total amount of exercises displayed in Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == exercises.count) {
            return 1
        }
        return exercises[section].sets.count + 2
    }
    
    // Loaded for each cell based on indexPath.section and indexPath.row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == exercises.count) {
            let addExerciseCell = self.tableView.dequeueReusableCell(withIdentifier: "AddExerciseCell", for: indexPath) as! AddExerciseCell
            addExerciseCell.delegate = self
            return addExerciseCell
        }
        else {
            if (indexPath.row == 0) {
                let exerciseCell = self.tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
                exerciseCell.setExercise(exercise: exercises[indexPath.section])
                exerciseCell.delegate = self
                return exerciseCell
            }
            else if (indexPath.row == exercises[indexPath.section].sets.count+1) {
                let addSetCell = self.tableView.dequeueReusableCell(withIdentifier: "AddSetCell", for: indexPath) as! AddSetCell
                addSetCell.delegate = self
                return addSetCell
            }
            else {
                let setCell = self.tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as! SetCell
                setCell.setSets(set: exercises[indexPath.section].sets[indexPath.row - 1])
                setCell.setCompletion(completion: exercises[indexPath.section].sets[indexPath.row - 1].completion)
                setCell.delegate = self
                return setCell
            }
        }
    }
    
    // Ensures the only rows that can be edited are sets and exercise cell (entire exercise section)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == (sectionsCount-1) || indexPath.row == exercises[indexPath.section].sets.count + 1 {
            return false
        }
        else {
            return true
        }
    }
    
    // Swipe to left to delete a set
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row == 0 {
                deleteEntireExercise(indexPath: indexPath)
            }
            else {
                deleteSetFromFirestore(set_id: exercises[indexPath.section].sets[indexPath.row-1].set_id)
                exercises[indexPath.section].sets.remove(at: indexPath.row - 1)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    func deleteEntireExercise(indexPath: IndexPath) {
        let sets_copy = exercises[indexPath.section].sets
        self.deleteExerciseFromFirestore(sets: sets_copy)
        exercises.remove(at: indexPath.section)
        sectionsCount = sectionsCount - 1
        tableView.beginUpdates()
        tableView.deleteSections([indexPath.section], with: .automatic)
        tableView.endUpdates()
    }
    
    func deleteExerciseFromFirestore(sets: [Set]) {
        for set in sets {
            Firestore.firestore().collection("users/\(self.uid)/workouts").document(set.set_id).delete()
        }
    }
    
    func deleteSetFromFirestore(set_id: String) {
        Firestore.firestore().collection("users/\(self.uid)/workouts").document(set_id).delete()
    }
}

// TODO: Make sure that its grabbing date range of the user's timezone
extension CollectionReference {
    func whereField(_ field: String, isDateInToday value: Date) -> Query {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
        guard
            let start = Calendar.current.date(from: components),
            let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
        else {
            fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isGreaterThan: start).whereField(field, isLessThan: end)
    }
}
