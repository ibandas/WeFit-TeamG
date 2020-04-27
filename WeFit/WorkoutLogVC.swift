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
        let sets: [Set] = [set1]
        let exercise1 = Exercise(title: "Bench Press", sets: sets)
        
        tempExercises.append(exercise1)
        
        print(tempExercises.count)
        return tempExercises
    }
}

extension WorkoutLog:  UITableViewDataSource, UITableViewDelegate {
    
    // TODO: Eventually make it "items.count + 1" to account for the "Add Exercises" cell
    func numberOfSections(in tableView: UITableView) -> Int {
        return exercises.count
    }
    
    // Total amount of exercises displayed in Table View
    // TODO: Eventually make an if else where if it's the last section, it's one row for "Add Exercises"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises[section].sets.count + 1
    }
    
    // Loaded for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let exerciseCell = self.tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
            exerciseCell.setExercise(exercise: exercises[indexPath.section])
            return exerciseCell
        }
        else {
            let setCell = self.tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as! SetCell
            setCell.RepLabel.text = "Reps:"
            setCell.WeightLabel.text = "Weight:"
            print(setCell)
            return setCell
        }
    }
}
