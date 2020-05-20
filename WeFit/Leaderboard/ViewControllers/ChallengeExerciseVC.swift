//
//  ChallengeExerciseVC.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/19/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

class ChallengeExerciseVC: UIViewController {
    
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
    var searchExercise = [String]()
    var searching = false
    
    var chosenExercises: [ChallengeExercise] = []
    
    @IBOutlet weak var exercisesTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exercises.sort()
        exercisesTV.delegate = self
        exercisesTV.dataSource = self
        self.searchBar.delegate = self
        
    }

}

extension ChallengeExerciseVC: ChallengePossibleExerciseCellDelegate {
    func didTapAddButtonAction(cell: ChallengePossibleExerciseCell) {
        let goalAmount = Int(cell.goalAmountInput.text!)
        let title = cell.exerciseTitle.text!
        if goalAmount != nil {
            if !cell.added {
                let addedExercise = ChallengeExercise(title: title, goalAmount: goalAmount!, added: true)
                self.chosenExercises.append(addedExercise)
            }
            else {
                if let index = self.chosenExercises.firstIndex(where: {$0.title == cell.exerciseTitle!.text}) {
                    self.chosenExercises.remove(at: index)
                }
            }
        }
    }
}

extension ChallengeExerciseVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchExercise.count
        } else {
            return exercises.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.exercisesTV.dequeueReusableCell(withIdentifier: "ChallengePossibleExerciseCell", for: indexPath) as! ChallengePossibleExerciseCell
        if searching {
            cell.setExerciseTitle(title: self.searchExercise[indexPath.row])
        } else {
            cell.setExerciseTitle(title: self.exercises[indexPath.row])
        }
        cell.delegate = self
        return cell
    }
}

extension ChallengeExerciseVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchExercise = exercises.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        self.exercisesTV.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.exercisesTV.reloadData()
    }
}
