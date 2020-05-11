//
//  ExerciseProfileCell.swift
//  WeFit
//
//  Created by Cristina Barclay on 5/8/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import UIKit

class ExerciseProfileCell: UITableViewCell {
    
    
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var weightNum: UILabel!
    @IBOutlet weak var repsNum: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

