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
    
@IBAction func emailLogin (_ sender: Any){
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let homePage = storyBoard.instantiateViewController(withIdentifier: "MainTabController") as! UITabBarController
    UIApplication.shared.windows.first?.rootViewController = homePage
}
    
}
