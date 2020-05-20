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
    
    let exercises = ["Pushup", "Squat", "Deadlift"]
    
    var searchExercise = [String]()
    var searching = false
    
    var chosenExercises: [ChallengeExercise] = []
    
    @IBOutlet weak var exercisesTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
