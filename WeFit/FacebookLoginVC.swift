// Swift
//
// Add this to the header of your file, e.g. in ViewController.swift

import UIKit
import Firebase
import FBSDKLoginKit

// Add this to the body
class FacebookLoginVC: UIViewController, LoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        view.addSubview(loginButton)
        
        loginButton.delegate = self
        loginButton.permissions = ["email", "public_profile"]
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error ?? "")
            return
        }
        signIn()
    }
    
    func signIn() {
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials, completion: {(user, error) in
            if error != nil {
                print("Something went wrong with our FB User: ", error ?? "")
                return
            }
            print("Successfully logged in with our user: ", user ?? "")
        })
        
        
        GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request", err ?? "")
                return
            }
            guard let json = result as? Dictionary<String, String> else {return}
            self.checkUserExist(json: json)
        }
    }
    // Creates a user document in "users" collection in Firestore if it doesn't exist
    func checkUserExist(json: Dictionary<String, String>) -> Void {
        let uid = Auth.auth().currentUser!.uid
        let email = json["email"]
        let name = json["name"]
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(uid)
        docRef.getDocument(completion: {(document, error) in
            if document!.exists {
                print("Document exists!")
            }
            else {
                print("Document doesn't exist!")
                // Add a new document with a generated ID
                db.collection("users").document(uid).setData([
                    "name": name!,
                    "email": email!
                ])
            }
        })
    }
}

