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

struct Competitor {
    var id: String
    var firstName: String
    var lastName: String
    var profilePicture: UIImage = UIImage(named: "pp1")!
    var points: Int
}
