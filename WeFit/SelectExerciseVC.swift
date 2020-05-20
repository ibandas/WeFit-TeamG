//
//  SelectExerciseVC.swift
//  WeFit
//
//  Created by Cristina Barclay on 5/19/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

class SelectExerciseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var exerciseTblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var exerciseList = ["Pushup", "Deadlift", "Squat", "Bench Press", "Russian Twist", "Irish twist", "Crunch", "Bicycle crunch"]
    
    var searchExercise = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exerciseTblView.dataSource = self
        self.exerciseTblView.delegate = self
        self.searchBar.delegate = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchExercise.count
        }else{
            return exerciseList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciselistcell", for: indexPath)
        if searching{
            cell.textLabel?.text = searchExercise[indexPath.row]
        }else{
            cell.textLabel?.text = exerciseList[indexPath.row]
        }
        return cell
    }


}

extension SelectExerciseVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchExercise = exerciseList.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        exerciseTblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        exerciseTblView.reloadData()
    }
}
