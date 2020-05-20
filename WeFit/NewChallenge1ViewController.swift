//
//  NewChallenge1ViewController.swift
//  WeFit
//
//  Created by Cristina Barclay on 5/16/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

class NewChallenge1ViewController: UIViewController {
    
    
    
    @IBOutlet weak var exerciseDrop: UIButton!
    @IBOutlet weak var exerciseTblView: UITableView!
    
    var exerciseList = ["Squats", "Pushups", "Deadlift"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
         exerciseTblView.isHidden = true

    }
    
    
    @IBAction func onClickExercise(_ sender: Any) {
        if exerciseTblView.isHidden{
                   animate(toggle: true)
               } else{
                   animate(toggle: false)
               }
    }
    
    func animate(toggle: Bool){
        if toggle {
        UIView.animate(withDuration: 0.3){
            self.exerciseTblView.isHidden = false
        }
        }else{
            UIView.animate(withDuration: 0.3){
            self.exerciseTblView.isHidden = true
            }
        }
    }
    
}

extension NewChallenge1ViewController: UITableViewDelegate, UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = exerciseList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exerciseDrop.setTitle("\(exerciseList[indexPath.row])", for: .normal)
        animate(toggle: false)
    }
}
