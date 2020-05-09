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

//    override func viewDidAppear(_ animated: Bool) {
//        if (AccessToken.isCurrentAccessTokenActive)
//        {
//            performSegue(withIdentifier: "goHome", sender: self)
//        }
//    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged out")
    }

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error ?? "")
            return
        }
        facebookSignIn()
    }


    // This logins with facebook and passes the credential to firebase
    func facebookSignIn() {
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

        // After successful login, sets new root controller at homepage
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let homePage = storyBoard.instantiateViewController(withIdentifier: "homeNavigation") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = homePage
    }

    // Creates a user document in "users" collection in Firestore if it doesn't exist
    func checkUserExist(json: Dictionary<String, String>) -> Void {
        let uid = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()

        let docRef = db.collection("users").document(uid)
        docRef.getDocument(completion: {(document, error) in
            if document!.exists {
                print("Document exists!")
            }
            else {
                // Add a new document with a generated ID
                print("Document doesn't exist!")
                let email = json["email"]
                let name = json["name"]
                var name_components = name!.components(separatedBy: " ")
                // Conditional for first and last name
                if name_components.count > 0 {
                    let firstName = name_components.removeFirst()
                    let lastName = name_components.joined(separator: " ")
                    db.collection("users").document(uid).setData([
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email!
                    ])
                }
                else {
                    db.collection("users").document(uid).setData([
                        "firstName": name!,
                        "email": email!
                    ])
                }
            }
        })
    }
}
