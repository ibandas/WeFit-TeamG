//
//  Competitor.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/11/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Competitor {
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var profilePicture: UIImage = UIImage(named: "pp1")!
    var points: Int = 0
    
    init(id: String, firstName: String, lastName: String, points: Int) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.points = points
    }
}
