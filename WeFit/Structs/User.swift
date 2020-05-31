//
//  User.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/16/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class User {
    var uid: String = Auth.auth().currentUser!.uid
    var firstName: String = ""
    var lastName: String = ""
    var profilePicture: UIImage = UIImage(named: "pp1")!
    
    static let sharedGlobal = User()
    
    func getFirebaseUser(completion: @escaping () -> ()) {
        let ref = Firestore.firestore().collection("users").document(self.uid)
        ref.getDocument(completion: {(snapshot, error) in
            if error != nil {
                print("Error")
            }
            else {
                guard let snap = snapshot else {return}
                let storageRef = Storage.storage().reference().child("profile/\(self.uid).jpg")
                
                storageRef.downloadURL(completion: {(url, error) in
                    do {
                        let data = try Data(contentsOf: url!)
                        self.profilePicture = UIImage(data: data as Data)!
                    } catch {
                        print("error")
                    }
                })
                
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

