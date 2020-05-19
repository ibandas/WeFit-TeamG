//
//  SelectExerciseVC.swift
//  WeFit
//
//  Created by Cristina Barclay on 5/19/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

class SelectExerciseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var exercisesTblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exercisesTblView

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           <#code#>
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           <#code#>
       }
    
}
