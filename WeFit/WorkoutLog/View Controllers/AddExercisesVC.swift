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
    
    var exercises: [AddExercise] = [AddExercise(title: "Bench Press"), AddExercise(title: "Squat"), AddExercise(title: "Deadlift"), AddExercise(title: "Pushup"), AddExercise(title: "Crunch"), AddExercise(title: "Bicycle Crunch"), AddExercise(title: "Sumo Squat"), AddExercise(title: "Jump Squat"), AddExercise(title: "Forward Lunge"), AddExercise(title: "Jumping Jack"), AddExercise(title: "Mountain Climber"), AddExercise(title: "Spiderman Mountain Climber"), AddExercise(title: "Superman"), AddExercise(title: "Glute Bridge"), AddExercise(title: "Russian Twist"), AddExercise(title: "Leg Lift Crunches"), AddExercise(title: "Frog Jump"), AddExercise(title: "Burpee"), AddExercise(title: "Plank Dip"), AddExercise(title: "Side Lunge"), AddExercise(title: "Up and Down Plank"), AddExercise(title: "V-Up"), AddExercise(title: "Reverse Crunch"), AddExercise(title: "Crunch Kickback"), AddExercise(title: "Leg Raise"), AddExercise(title: "Scissor"), AddExercise(title: "Flutter Kick"), AddExercise(title: "Side Leg Raise"), AddExercise(title: "Knee to Elbow"), AddExercise(title: "Heel Touch"), AddExercise(title: "Cross Crunch"), AddExercise(title: "Donkey Kick"), AddExercise(title: "Fire Hydrant"), AddExercise(title: "Cross Over Extension"), AddExercise(title: "Leg Pulse"), AddExercise(title: "Inchwork"), AddExercise(title: "Tuck Jump"), AddExercise(title: "Bear Crawl"), AddExercise(title: "Curtsy Lunge"), AddExercise(title: "Single Leg Deadlift"), AddExercise(title: "Step Up"), AddExercise(title: "Calf Raise"), AddExercise(title: "Diamond Pushup"), AddExercise(title: "Situp"), AddExercise(title: "Sprinter Situp"), AddExercise(title: "Barbell Lunge"), AddExercise(title: "Bench Dip"), AddExercise(title: "Bicep Curl"), AddExercise(title: "Upright Row"), AddExercise(title: "Tricep Kickback"), AddExercise(title: "Bent Over Reverse Fly"), AddExercise(title: "Overhead Shoulder Press"), AddExercise(title: "Hammer Curl"), AddExercise(title: "Lateral Lunge"), AddExercise(title: "Stutter Step"), AddExercise(title: "Leaning Camel"), AddExercise(title: "Bird Dog"), AddExercise(title: "Toe Touch Crunch"), AddExercise(title: "Dumbbell Side Bend"), AddExercise(title: "Shoulder Tap"), AddExercise(title: "Wide Curl"), AddExercise(title: "High Cable Curl"), AddExercise(title: "Reverse Fly"), AddExercise(title: "Hip Abduction"), AddExercise(title: "Windshield Wiper"), AddExercise(title: "Shoulder Fly"), AddExercise(title: "Pullover"), AddExercise(title: "Lateral Leg Raise"), AddExercise(title: "Kettlebell Swing"), AddExercise(title: "Oblique Leg Crunch"), AddExercise(title: "Long Arm Crunch"), AddExercise(title: "Vertical Leg Crunch"), AddExercise(title: "Crunch Twist"), AddExercise(title: "Skater Squat"), AddExercise(title: "Walking Lunge"), AddExercise(title: "Lunge Jump"), AddExercise(title: "Quadrupled Leg Lift")]
    
    var searchExercise: [AddExercise] = []
    var searching: Bool = false
    var already_chosen_exercises: [String] = []
    var selectedExercises: [String] = []

    
    override func viewDidLoad() {
        self.removeExerciseDifferences(completion: {result in
            self.exercises = result
            self.exercises.sort(by: {$0.title < $1.title})
            self.possibleExercisesTV.reloadData()
        })
        super.viewDidLoad()
        self.possibleExercisesTV.delegate = self
        self.possibleExercisesTV.dataSource = self
        self.searchBar.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        for possibleExercise in self.exercises {
            if possibleExercise.added == true {
                self.selectedExercises.append(possibleExercise.title)
            }
        }
    }
    
    func removeExerciseDifferences(completion: @escaping ([AddExercise]) -> ()) {
        var tempExercises: [AddExercise] = []
        for exercise in self.exercises {
            if !self.already_chosen_exercises.contains(where: {$0 == exercise.title}) {
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
            possibleExerciseCell.setPossibleExerciseTitle(title: searchExercise[indexPath.row].title)
            if (self.searchExercise[indexPath.row].added) {
                possibleExerciseCell.accessoryType = .checkmark
            }
            else {
                possibleExerciseCell.accessoryType = .none
            }
        } else {
            possibleExerciseCell.setPossibleExerciseTitle(title: exercises[indexPath.row].title)
            if (self.exercises[indexPath.row].added) {
                possibleExerciseCell.accessoryType = .checkmark
            }
            else {
                possibleExerciseCell.accessoryType = .none
            }
        }
        return possibleExerciseCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.exercises[indexPath.row].added) {
            possibleExercisesTV.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            self.exercises[indexPath.row].added = false
        }
        else {
            possibleExercisesTV.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            self.exercises[indexPath.row].added = true
        }
    }
}

extension AddExercisesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchExercise = exercises.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        self.possibleExercisesTV.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.possibleExercisesTV.reloadData()
    }
}
