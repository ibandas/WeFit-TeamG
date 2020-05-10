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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loadWorkouts()
    }
    
    func loadWorkouts() {
        let uid = Auth.auth().currentUser!.uid
        // let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        let ref = Firestore.firestore().collection("users/\(uid)/workouts").whereField("created_at", isDateInToday: Date())
        
        ref.getDocuments(completion: {(snapshot, error) in
            if error != nil {
                print("Error")
            }
            else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let id = document.documentID
                    let data = document.data()
                    let created_at = data["created_at"] as? Date ?? Date()
                    let exercise_title = data["title"] as? String ?? ""
                    print(exercise_title)
                    var set_id: Int = 1
                    var sets: [Set] = []
                    while true {
                        var set: String = "set_" + String(set_id)
                        let setDB = data[set] as? Array<Int>
                        if setDB != nil {
                            sets.append(Set(set_id: set, weight: setDB![0], reps: setDB![1]))
                            print("Set Exists")
                            set = String(set.dropLast())
                            set_id += 1
                        }
                        else {
                            print("Breaking")
                            break
                        }
                    }
                    self.exercises.append(Exercise(exercise_id: id, title: exercise_title, sets: sets, created_at: created_at))
                }
            }
            self.setSectionsCount()
            self.tableView.reloadData()
        })
    }
    
    // Adds set to exercise data and row to the VC
    func addSet(indexPath: IndexPath) {
        let exercise_id = exercises[indexPath.section].exercise_id
        let uid = Auth.auth().currentUser!.uid
        let ref = Firestore.firestore().collection("users/\(uid)/workouts").document(exercise_id)
        let id: Int = exercises[indexPath.section].sets.count
        let set_id: String = "set_" + String(id)
        let set: Set = Set(set_id: set_id, weight: 0, reps: 0)
        exercises[indexPath.section].sets.append(set)
        ref.updateData([
            set_id: [0, 0]
        ]) { err in
            if let err = err {
                print(err)
            } else {
                print("Success adding set")
            }
        }
        
        
        
        let indexPath = IndexPath(row: exercises[indexPath.section].sets.count, section: indexPath.section)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func updateExerciseinFirestore(exercise_id: String, set_id: String, weight: Int, reps: Int) {
        let uid = Auth.auth().currentUser!.uid
        let ref = Firestore.firestore().collection("users/\(uid)/workouts").document(exercise_id)
        ref.updateData([
            set_id: [weight, reps]
        ]) { err in
            if let err = err {
                print(err)
            } else {
                print("Success adding set")
            }
        }
    }
    
    
    // Updates an Exercises's Set's Weight value
    func updateWeight(indexPath: IndexPath, cell: SetCell) {
        if let weightNum = Int(cell.WeightEntry.text!) {
            exercises[indexPath.section].sets[indexPath.row - 1].weight = weightNum
            let setTemp: Set = exercises[indexPath.section].sets[indexPath.row - 1]
            self.updateExerciseinFirestore(exercise_id: exercises[indexPath.section].exercise_id,
                                           set_id: setTemp.set_id,
                                           weight: weightNum,
                                           reps: setTemp.reps)
        }
    }
    
    // Updates an Exercise's Set's Reps value
    func updateReps(indexPath: IndexPath, cell: SetCell) {
        if let repsNum = Int(cell.RepEntry.text!) {
            exercises[indexPath.section].sets[indexPath.row - 1].reps = repsNum
            let setTemp: Set = exercises[indexPath.section].sets[indexPath.row - 1]
            self.updateExerciseinFirestore(exercise_id: exercises[indexPath.section].exercise_id,
                                           set_id: setTemp.set_id,
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
        print(exercises.count)
    }
    
    
    @IBAction func unwindFromAddExercisesVC(_ sender: UIStoryboardSegue) {
        if sender.source is AddExercisesVC {
            if let senderVC = sender.source as? AddExercisesVC {
                exercises += senderVC.selectedExercises
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

// Extension of VC for SetCell that allows updates of weight/reps
extension WorkoutLog: SetCellDelegate {
    func updateWeight(cell: SetCell) {
        let indexPath = self.tableView.indexPath(for: cell)!
        updateWeight(indexPath: indexPath, cell: cell)
    }
    func updateReps(cell: SetCell) {
        let indexPath = self.tableView.indexPath(for: cell)!
        updateReps(indexPath: indexPath, cell: cell)
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
                exercises[indexPath.section].sets.remove(at: indexPath.row - 1)
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    func deleteEntireExercise(indexPath: IndexPath) {
        exercises.remove(at: indexPath.section)
        sectionsCount = sectionsCount - 1
        tableView.beginUpdates()
        tableView.deleteSections([indexPath.section], with: .automatic)
        tableView.endUpdates()
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
