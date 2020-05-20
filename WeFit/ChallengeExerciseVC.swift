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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE")
    }
    
    let exercises = ["Pushup", "Squat", "Deadlift"]
    var chosenExercises: [ChallengeExercise] = []
    
    @IBOutlet weak var exercisesTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exercisesTV.delegate = self
        exercisesTV.dataSource = self
    }

}

extension ChallengeExerciseVC: ChallengePossibleExerciseCellDelegate {
    func didTapAddButtonAction(cell: ChallengePossibleExerciseCell) {
        print("button pressed")
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
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.exercisesTV.dequeueReusableCell(withIdentifier: "ChallengePossibleExerciseCell", for: indexPath) as! ChallengePossibleExerciseCell
        cell.setExerciseTitle(title: self.exercises[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    
}
