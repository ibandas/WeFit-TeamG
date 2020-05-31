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
    
    @IBAction func changeUsername( sender: Any) {
        //this could be adapted to allow for first, last, middle, but that is probably of lesser importance and most will use just first
        User.sharedGlobal.firstName = newName.text!;
        viewDidLoad();
    }

    @IBAction func changeProfileImage(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    var newImage: UIImage

    if let possibleImage = info[.editedImage] as? UIImage {
        newImage = possibleImage
    } else if let possibleImage = info[.originalImage] as? UIImage {
        newImage = possibleImage
    } else {
        return
    }

    // do something interesting here!
    User.sharedGlobal.profilePicture = newImage;

    dismiss(animated: true)
    viewDidLoad();
    }
    
    @IBOutlet weak var newName: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    override func viewDidLoad() {
        self.profilePic.image = User.sharedGlobal.profilePicture
        self.profileName.text = User.sharedGlobal.firstName
        super.viewDidLoad()
        self.view.bringSubviewToFront(profilePic)
        
    }
}
