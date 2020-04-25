//
//  WorkoutLogTVC.swift
//  WeFit
//
//  Created by Irinel Bandas on 4/25/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.


import UIKit

class WorkoutLog: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var exercises: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercises = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func createArray() -> [String] {
        var tempExercises: [String] = []
        let exercise1 = "Bench Press"
        
        tempExercises.append(exercise1)
        
        return tempExercises
    }
}

extension WorkoutLog:  UITableViewDataSource, UITableViewDelegate {
    
    // Total amount of exercises displayed in Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    // Loaded for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exercise = exercises[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell") as! ExerciseCell
        
        cell.setExercise(exercise: exercise)
        
        return cell
    }
}
