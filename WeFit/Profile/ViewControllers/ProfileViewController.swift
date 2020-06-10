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
        } catch let signOutError {
          print ("Error signing out: %@", signOutError)
        }
        LoginManager().logOut()
        AccessToken.current = nil
        if let loginVC = self.storyboard?.instantiateViewController(identifier: "login") as? FacebookLoginVC {
            present(loginVC, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var pastChallengesTblView: UITableView!
    
    var challenges_titles = ["Do 50 pushups", "Do 100 squats", "Run 20 miles", "Do 75 Donkey Kicks", "Do 50 Burpees"]
    var ranks = ["1", "4", "6", "3","4"]
    var your_points = ["50", "81", "5", "53", "38"]
    var points = ["50", "100", "20", "75", "50"]
    
 
    
    override func viewDidLoad() {
        
        self.profilePic.image = User.sharedGlobal.profilePicture
        self.profileName.text = User.sharedGlobal.firstName
        super.viewDidLoad()
        self.view.bringSubviewToFront(profilePic)
        self.pastChallengesTblView.delegate = self
        self.pastChallengesTblView.dataSource = self
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges_titles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.pastChallengesTblView.dequeueReusableCell(withIdentifier: "pastChallengesCell", for: indexPath) as! PastChallengeTableViewCell
            
        cell.indexPath = indexPath
        cell.challengeTitle.text = challenges_titles[indexPath.row]
        cell.rank.text = ranks[indexPath.row]
        cell.pointsUser.text = your_points[indexPath.row]
        cell.pointsOut.text = points[indexPath.row]
        return cell
    }
    
}

