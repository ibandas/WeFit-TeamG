//
//  User.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/16/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class User {
    var uid: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var profilePicture: UIImage = UIImage(named: "pp1")!
    
    init() {
        self.getFirebaseUser() {
            print("Name: \(self.firstName) \(self.lastName)")
        }
    }
    
    // This only to be used for the user logged in
    func getFirebaseUser(completion: @escaping () -> ()) {
        self.uid = Auth.auth().currentUser!.uid
        let ref = Firestore.firestore().collection("users").document(self.uid)
        ref.getDocument(completion: {(snapshot, error) in
            if error != nil {
                print("Error")
            }
            else {
                guard let snap = snapshot else {return}
                let data = snap.data()
                self.setFirstName(firstName: data!["firstName"] as! String)
                self.setLastName(lastName: data!["lastName"] as! String)
            }
            completion()
        })
    }
    
    func setUID(uid: String) -> Void {
        self.uid = uid
    }
    
    func setFirstName(firstName: String) -> Void {
        self.firstName = firstName
    }
    
    func setLastName(lastName: String) -> Void {
        self.lastName = lastName
    }
}
