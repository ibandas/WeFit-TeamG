//
//  LoginViewController.swift
//  WeFit
//
//  Created by Cristina Barclay on 5/2/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let mainTabController = storyboard?.instantiateViewController(identifier: "MainTabController") as! MainTabController
               
        present(mainTabController, animated: true, completion: nil)
    }
    
        
    
    
}
