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
  
    @IBOutlet weak var possibleSearchBar: UISearchBar!
    @IBOutlet weak var addButtonPressed: UIBarButtonItem!
    
    var exercises: [String] = ["Bench Press", "Squat", "Deadlift", "Pushup"]
    var already_chosen_exercises: [String] = []
    var selectedExercises: [String] = []
    
    var searchExercise = [String]()
    var searching = false

    
    override func viewDidLoad() {
        self.removeExerciseDifferences(completion: {result in
            self.exercises = result
            self.possibleExercisesTV.reloadData()
        })
        super.viewDidLoad()
        possibleExercisesTV.delegate = self
        possibleExercisesTV.dataSource = self
        self.possibleSearchBar.delegate = self
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
        if searching{
            return searchExercise.count
        }else{
            return exercises.count
        }    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let possibleExerciseCell = self.possibleExercisesTV.dequeueReusableCell(withIdentifier: "PossibleExerciseCell", for: indexPath) as! PossibleExerciseCell
        if searching{
            possibleExerciseCell.setPossibleExerciseTitle(title: searchExercise[indexPath.row])
        }else{
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

extension AddExercisesVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchExercise = exercises.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        possibleExercisesTV.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        possibleSearchBar.text = ""
        possibleExercisesTV.reloadData()
    }
}
