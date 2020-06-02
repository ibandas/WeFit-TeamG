//
//  CreateNewAccount.swift
//  WeFit
//
//  Created by Nicholas Trotter on 5/31/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKLoginKit

class CreateNewAccount : UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    var pictureSet: bool = false;
    
    @IBAction func addImage(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
    FacebookLoginVC().uploadImage(image: newImage, uid: User.sharedGlobal.uid);
    dismiss(animated: true)
        pictureSet = true;
    }
    
@IBAction func createAccount (_ sender: Any){
    if pictureSet == false{
        let alertController = UIAlertController(title: "Profile Picture Missing", message: "No Profile Picture Selected", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    else if password.text != passwordConfirm.text {
    let alertController = UIAlertController(title: "Password Incorrect", message: "Passwords do not match", preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
    alertController.addAction(defaultAction)
    self.present(alertController, animated: true, completion: nil)
            }
    else{
        Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
     if error == nil {
        User.sharedGlobal.firstName = self.username.text!;
       self.performSegue(withIdentifier: "signupToHome", sender: self)
                    }
     else{
       let alertController = UIAlertController(title: "Something went Wrong!", message: error?.localizedDescription, preferredStyle: .alert)
       let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
           }
                }
    }
    
    
}
    
}
