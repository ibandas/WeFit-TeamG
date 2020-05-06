// Swift
//
// Add this to the header of your file, e.g. in ViewController.swift

import UIKit
import FBSDKLoginKit

// Add this to the body
class FacebookLoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
    }

}
