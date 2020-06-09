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
    
    var exercises: [ChallengeExercise] = [ChallengeExercise(title: "Bench Press"), ChallengeExercise(title: "Squat"), ChallengeExercise(title: "Deadlift"), ChallengeExercise(title: "Pushup"), ChallengeExercise(title: "Crunch"), ChallengeExercise(title: "Bicycle Crunch"), ChallengeExercise(title: "Sumo Squat"), ChallengeExercise(title: "Jump Squat"), ChallengeExercise(title: "Forward Lunge"), ChallengeExercise(title: "Jumping Jack"), ChallengeExercise(title: "Mountain Climber"), ChallengeExercise(title: "Spiderman Mountain Climber"), ChallengeExercise(title: "Superman"), ChallengeExercise(title: "Glute Bridge"), ChallengeExercise(title: "Russian Twist"), ChallengeExercise(title: "Leg Lift Crunches"), ChallengeExercise(title: "Frog Jump"), ChallengeExercise(title: "Burpee"), ChallengeExercise(title: "Plank Dip"), ChallengeExercise(title: "Side Lunge"), ChallengeExercise(title: "Up and Down Plank"), ChallengeExercise(title: "V-Up"), ChallengeExercise(title: "Reverse Crunch"), ChallengeExercise(title: "Crunch Kickback"), ChallengeExercise(title: "Leg Raise"), ChallengeExercise(title: "Scissor"), ChallengeExercise(title: "Flutter Kick"), ChallengeExercise(title: "Side Leg Raise"), ChallengeExercise(title: "Knee to Elbow"), ChallengeExercise(title: "Heel Touch"), ChallengeExercise(title: "Cross Crunch"), ChallengeExercise(title: "Donkey Kick"), ChallengeExercise(title: "Fire Hydrant"), ChallengeExercise(title: "Cross Over Extension"), ChallengeExercise(title: "Leg Pulse"), ChallengeExercise(title: "Inchwork"), ChallengeExercise(title: "Tuck Jump"), ChallengeExercise(title: "Bear Crawl"), ChallengeExercise(title: "Curtsy Lunge"), ChallengeExercise(title: "Single Leg Deadlift"), ChallengeExercise(title: "Step Up"), ChallengeExercise(title: "Calf Raise"), ChallengeExercise(title: "Diamond Pushup"), ChallengeExercise(title: "Situp"), ChallengeExercise(title: "Sprinter Situp"), ChallengeExercise(title: "Barbell Lunge"), ChallengeExercise(title: "Bench Dip"), ChallengeExercise(title: "Bicep Curl"), ChallengeExercise(title: "Upright Row"), ChallengeExercise(title: "Tricep Kickback"), ChallengeExercise(title: "Bent Over Reverse Fly"), ChallengeExercise(title: "Overhead Shoulder Press"), ChallengeExercise(title: "Hammer Curl"), ChallengeExercise(title: "Lateral Lunge"), ChallengeExercise(title: "Stutter Step"), ChallengeExercise(title: "Leaning Camel"), ChallengeExercise(title: "Bird Dog"), ChallengeExercise(title: "Toe Touch Crunch"), ChallengeExercise(title: "Dumbbell Side Bend"), ChallengeExercise(title: "Shoulder Tap"), ChallengeExercise(title: "Wide Curl"), ChallengeExercise(title: "High Cable Curl"), ChallengeExercise(title: "Reverse Fly"), ChallengeExercise(title: "Hip Abduction"), ChallengeExercise(title: "Windshield Wiper"), ChallengeExercise(title: "Shoulder Fly"), ChallengeExercise(title: "Pullover"), ChallengeExercise(title: "Lateral Leg Raise"), ChallengeExercise(title: "Kettlebell Swing"), ChallengeExercise(title: "Oblique Leg Crunch"), ChallengeExercise(title: "Long Arm Crunch"), ChallengeExercise(title: "Vertical Leg Crunch"), ChallengeExercise(title: "Crunch Twist"), ChallengeExercise(title: "Skater Squat"), ChallengeExercise(title: "Walking Lunge"), ChallengeExercise(title: "Lunge Jump"), ChallengeExercise(title: "Quadrupled Leg Lift")]
    
    var searchExercise = [ChallengeExercise]()
    var searching = false
    
    var chosenExercises: [ChallengeExercise] = []
    
    @IBOutlet weak var exercisesTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exercises.sort(by: {$0.title < $1.title})
        exercisesTV.delegate = self
        exercisesTV.dataSource = self
        self.searchBar.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        for chosenExercise in self.exercises {
            if chosenExercise.added == true {
                self.chosenExercises.append(chosenExercise)
            }
        }
        print(self.chosenExercises)
    }

}

extension ChallengeExerciseVC: ChallengePossibleExerciseCellDelegate {
    func didTapAddButtonAction(cell: ChallengePossibleExerciseCell) {
        let indexPath = exercisesTV.indexPath(for: cell)
        let goalAmount = Int(cell.goalAmountInput.text!)
        if searching {
            let tempExerciseTitle = self.searchExercise[indexPath!.row].title
            let idx: Int = self.exercises.firstIndex(where: {$0.title == tempExerciseTitle})!
            if self.searchExercise[indexPath!.row].added {
                self.searchExercise[indexPath!.row].added = false
                self.exercises[idx].added = false
            } else {
                self.searchExercise[indexPath!.row].goalAmount = goalAmount!
                self.searchExercise[indexPath!.row].added = true
                self.exercises[idx].added = true
            }
        }
        else {
            if self.exercises[indexPath!.row].added {
                self.exercises[indexPath!.row].added = false
            } else {
                self.exercises[indexPath!.row].goalAmount = goalAmount!
                self.exercises[indexPath!.row].added = true
            }
        }
    }
    
    func updateGoalAmount(cell: ChallengePossibleExerciseCell) {
        if let indexPath = exercisesTV.indexPath(for: cell) {
            if let fieldGoalAmount = Int(cell.goalAmountInput.text!) {
                if searching {
                    let tempExerciseTitle = self.searchExercise[indexPath.row].title
                    let idx: Int = self.exercises.firstIndex(where: {$0.title == tempExerciseTitle})!
                    self.searchExercise[indexPath.row].goalAmount = fieldGoalAmount
                    self.exercises[idx].goalAmount = fieldGoalAmount
                }
                else {
                    self.exercises[indexPath.row].goalAmount = Int(cell.goalAmountInput.text!)!
                }
            }
            else {
                print("Error in updating the goal amount due to nil amount")
            }
        }
        else {
            print("Error in updating the goal amount due to index path")
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
            cell.setExerciseTitle(title: self.searchExercise[indexPath.row].title)
            cell.setAddButton(added: self.searchExercise[indexPath.row].added)
            cell.setGoalAmount(goal: self.searchExercise[indexPath.row].goalAmount)
        }
        else {
            cell.setExerciseTitle(title: self.exercises[indexPath.row].title)
            cell.setAddButton(added: self.exercises[indexPath.row].added)
            cell.setGoalAmount(goal: self.exercises[indexPath.row].goalAmount)
        }
        cell.delegate = self
        return cell
    }
}

extension ChallengeExerciseVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchExercise = exercises.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        self.exercisesTV.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.exercisesTV.reloadData()
        }
    }
}
