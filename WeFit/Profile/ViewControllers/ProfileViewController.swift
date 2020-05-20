//
//  ProfileViewController.swift
//  WeFit
//
//  Created by Cristina Barclay on 5/8/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as Error {
          print ("Error signing out: %@", signOutError)
        }
        LoginManager().logOut()
        if let loginVC = self.storyboard?.instantiateViewController(identifier: "login") as? FacebookLoginVC {
            present(loginVC, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
//    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var datePicker: UIDatePicker!
//    @IBOutlet weak var workoutList: UITableView!
    
//    var workouts = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view.bringSubviewToFront(label)
        self.view.bringSubviewToFront(profilePic)
        
        self.profilePic.image = User.sharedGlobal.profilePicture
        self.profileName.text = User.sharedGlobal.firstName
        
    }
}
    
//        datePicker.datePickerMode = UIDatePicker.Mode.date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMMM yyyy"
//        datePicker.setValue(UIColor.darkGray, forKeyPath: "textColor")
//        let selectedDate = dateFormatter.string(from: datePicker.date)
//        print(selectedDate)
    

        // Load the sample data.
//         loadProfile()
//         loadWorkout()
//         workoutList.dataSource = self
//         workoutList.delegate = self
    
//    private func loadProfile() {
//
//        let photo1 = UIImage(named: "pp1")!
//        let person = Profile(name: "Amanda Stiglich", photo: photo1)
//
//        profileName.text = person.name
//        profilePic.image = person.photo
//    }
    
//    private func loadWorkout(){
//        let set1 = Set(set_id: "", weight: 0, reps: 50)
//        let sets1: [Set] = [set1]
//        let exercise1 = Exercise(title: "Pushups", sets: sets1)
//        workouts = [exercise1]
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return workouts.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exercisecell", for: indexPath) as? ExerciseProfileCell else {
//        fatalError("The dequeued cell is not an instance of feedTableViewCell.")
//        }
//
//        let exercise = workouts[indexPath.row]
//        let set = exercise.sets[indexPath.row]
//        cell.workoutName.text = exercise.title
//        cell.weightNum.text = String(set.weight)
//        cell.repsNum.text = String(set.reps)
//
//
//        return cell
//
//    }
    
//}
