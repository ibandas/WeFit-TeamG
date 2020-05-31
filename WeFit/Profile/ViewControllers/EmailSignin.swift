//
//  EmailSignin.swift
//  WeFit
//
//  Created by Nicholas Trotter on 5/31/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FBSDKLoginKit

class EmailSignin : UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
@IBAction func emailLogin ( sender: Any){
    Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
       if error == nil{
         self.performSegue(withIdentifier: "loginToHome", sender: self)
                      }
        else{
         let alertController = UIAlertController(title: "Error during Login", message: error?.localizedDescription, preferredStyle: .alert)
         let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
          alertController.addAction(defaultAction)
          self.present(alertController, animated: true, completion: nil)
             }
    }
}
    
}
