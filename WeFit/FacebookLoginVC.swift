// Swift
//
// Add this to the header of your file, e.g. in ViewController.swift

import UIKit
import FBSDKLoginKit

// Add this to the body
class FacebookLoginVC: UIViewController, LoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        loginButton.delegate = self
        loginButton.permissions = ["email", "public_profile"]
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Successfully logged in with facebook...")
        GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request", err)
                return
            }
            
            print(result)
        }
    }

}
