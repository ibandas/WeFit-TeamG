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
    
    override func viewDidLoad() {
        
        self.profilePic.image = User.sharedGlobal.profilePicture
        self.profileName.text = User.sharedGlobal.firstName
        super.viewDidLoad()
        self.view.bringSubviewToFront(profilePic)
        
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.pastChallengesTblView.dequeueReusableCell(withIdentifier: "pastChallenfesCell", for: indexPath) as! PastChallengeCell
        cell.setPastChallenge(challenge: challenges.challenges[indexPath.row], uid: self.uid, indexPath: indexPath)
        return cell
    }
    
}
