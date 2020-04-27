//
//  WorkoutLogTVC.swift
//  WeFit
//
//  Created by Irinel Bandas on 4/25/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.


import UIKit

class WorkoutLog: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var exercises: [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercises = createArray()
        
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
}

extension WorkoutLog:  UITableViewDataSource, UITableViewDelegate {
    
    // TODO: Eventually make it "items.count + 1" to account for the "Add Exercises" cell
    func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count + 1
    }
    
    // Total amount of exercises displayed in Table View
    // TODO: Eventually make an if else where if it's the last section, it's one row for "Add Exercises"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == exercises.count) {
            return 1
        }
        return exercises[section].sets.count + 2
    }
    
    // Loaded for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == exercises.count) {
            let addExerciseCell = self.tableView.dequeueReusableCell(withIdentifier: "AddExerciseCell", for: indexPath) as! AddExerciseCell
            return addExerciseCell
        }
        else {
            if (indexPath.row == 0) {
                let exerciseCell = self.tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
                exerciseCell.setExercise(exercise: exercises[indexPath.section])
                return exerciseCell
            }
            else if (indexPath.row == exercises[indexPath.section].sets.count) {
                let addSetCell = self.tableView.dequeueReusableCell(withIdentifier: "AddSetCell", for: indexPath) as! AddSetCell
                return addSetCell
            }
            else {
                let setCell = self.tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as! SetCell
                setCell.RepLabel.text = "Reps:"
                setCell.WeightLabel.text = "Weight:"
                return setCell
            }
        }
    }
}
