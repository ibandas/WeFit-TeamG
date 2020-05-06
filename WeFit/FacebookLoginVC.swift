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
        showEmailAddress()
    }
    
    func showEmailAddress() {
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
            print(result ?? "")
        }
    }

}
