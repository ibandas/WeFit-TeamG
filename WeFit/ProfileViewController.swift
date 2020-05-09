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

class ProfileViewController: UIViewController{

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private func loadProfile() {

    let photo1 = UIImage(named: "pp1")!
    let workoutList = [Workout]()
    let person = Profile(name: "Nicole", photo: photo1, workouts: workoutList)
        
    profileName.text = person.name
    profilePic.image = person.photo
    
}

override func viewDidLoad() {
         super.viewDidLoad()
    
        self.view.bringSubviewToFront(label)
    
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        let selectedDate = dateFormatter.string(from: datePicker.date)
        print(selectedDate)
    

   

        // Load the sample data.
         loadProfile()
     }
}
