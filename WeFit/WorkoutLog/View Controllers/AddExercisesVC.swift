//
//  AddExercisesVC.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/2/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

class AddExercisesVC: UIViewController {
    
    @IBOutlet weak var possibleExercisesTV: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButtonPressed: UIBarButtonItem!
    
    var exercises: [String] = ["Bench Press", "Squat", "Deadlift", "Pushup", "Crunch", "Bicycle Crunch", "Sumo Squat",
    "Jump Squat", "Forward Lunge", "Jumping Jack", "Mountain Climber", "Spiderman Mountain Climber", "Superman",
    "Glute Bridge", "Russian Twist", "Leg Lift Crunches", "Frog Jump", "Burpee", "Plank Dip", "Side Lunge", "Up and Down Plank",
    "V-Up", "Reverse Crunch", "Crunch Kickback", "Leg Raise", "Scissor", "Flutter Kick", "Side Leg Raise", "Knee to Elbow",
    "Heel Touch", "Cross Crunch", "Donkey Kick", "Fire Hydrant", "Cross Over Extension", "Leg Pulse", "Inchwork", "Tuck Jump",
    "Bear Crawl", "Curtsy Lunge", "Single Leg Deadlift", "Step Up", "Calf Raise", "Diamond Pushup",
    "Situp", "Sprinter Situp", "Barbell Lunge", "Bench Dip", "Bicep Curl", "Upright Row", "Tricep Kickback",
    "Bent Over Reverse Fly", "Overhead Shoulder Press", "Hammer Curl", "Lateral Lunge", "Stutter Step", "Leaning Camel",
    "Bird Dog", "Toe Touch Crunch", "Dumbbell Side Bend", "Shoulder Tap", "Wide Curl", "High Cable Curl", "Reverse Fly",
    "Hip Abduction", "Windshield Wiper", "Shoulder Fly", "Pullover", "Lateral Leg Raise", "Kettlebell Swing",
    "Oblique Leg Crunch", "Long Arm Crunch", "Vertical Leg Crunch", "Crunch Twist", "Skater Squat", "Walking Lunge",
    "Lunge Jump", "Quadrupled Leg Lift"]
    
    var searchExercise: [String] = []
    var searching: Bool = false
    var already_chosen_exercises: [String] = []
    var selectedExercises: [String] = []

    
    override func viewDidLoad() {
        self.removeExerciseDifferences(completion: {result in
            self.exercises = result
            self.exercises.sort()
            self.possibleExercisesTV.reloadData()
        })
        super.viewDidLoad()
        self.possibleExercisesTV.delegate = self
        self.possibleExercisesTV.dataSource = self
        self.searchBar.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cells = self.possibleExercisesTV.visibleCells as! [PossibleExerciseCell]
        for cell in cells {
            if(cell.accessoryType == UITableViewCell.AccessoryType.checkmark) {
                let title: String = cell.possibleExerciseTitle.text!
                selectedExercises.append(title)
            }
        }
    }
    
    func removeExerciseDifferences(completion: @escaping ([String]) -> ()) {
        var tempExercises: [String] = []
        for exercise in self.exercises {
            if !self.already_chosen_exercises.contains(exercise) {
                tempExercises.append(exercise)
            }
        }
        completion(tempExercises)
    }
}

extension AddExercisesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchExercise.count
        } else {
            return exercises.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let possibleExerciseCell = self.possibleExercisesTV.dequeueReusableCell(withIdentifier: "PossibleExerciseCell", for: indexPath) as! PossibleExerciseCell
       
        if searching {
            possibleExerciseCell.setPossibleExerciseTitle(title: searchExercise[indexPath.row])
        } else {
            possibleExerciseCell.setPossibleExerciseTitle(title: exercises[indexPath.row])
        }
        return possibleExerciseCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (possibleExercisesTV.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark) {
            possibleExercisesTV.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        else {
            possibleExercisesTV.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
    }
}

extension AddExercisesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchExercise = exercises.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        self.possibleExercisesTV.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.possibleExercisesTV.reloadData()
    }
}
