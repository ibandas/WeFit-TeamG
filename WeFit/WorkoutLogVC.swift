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
        exercises = createArray()
        setSectionsCount()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func createArray() -> [Exercise] {
        var tempExercises: [Exercise] = []
        let set1 = Set(weight: 250, reps: 10)
        let set2 = Set(weight: 400, reps: 6)
        let sets1: [Set] = [set1]
        let sets2: [Set] = [set2]
        let exercise1 = Exercise(title: "Bench Press", sets: sets1)
        let exercise2 = Exercise(title: "Squat", sets: sets2)
        
        tempExercises.append(exercise1)
        tempExercises.append(exercise2)
    
        return tempExercises
    }
    
    // Adds set to exercise data and row to the VC
    func addSet(indexPath: IndexPath) {
        exercises[indexPath.section].sets.append(Set(weight: 0, reps: 0))
        
        let indexPath = IndexPath(row: exercises[indexPath.section].sets.count, section: indexPath.section)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    // Updates an Exercises's Set's Weight value
    func updateWeight(indexPath: IndexPath, cell: SetCell) {
        if let weightNum = Int(cell.WeightEntry.text!) {
            exercises[indexPath.section].sets[indexPath.row - 1].weight = weightNum
        }
    }
    
    // Updates an Exercise's Set's Reps value
    func updateReps(indexPath: IndexPath, cell: SetCell) {
        if let repsNum = Int(cell.RepEntry.text!) {
            exercises[indexPath.section].sets[indexPath.row - 1].reps = repsNum
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
