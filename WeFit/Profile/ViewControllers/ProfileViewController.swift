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
    
    override func viewDidLoad() {
        self.profilePic.image = User.sharedGlobal.profilePicture
        self.profileName.text = User.sharedGlobal.firstName
        super.viewDidLoad()
        self.view.bringSubviewToFront(profilePic)
        
    }
}
