//
//  PossibleExerciseCell.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/2/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

class PossibleExerciseCell: UITableViewCell {

    @IBOutlet weak var possibleExerciseTitle: UILabel!
    
    func setPossibleExerciseTitle(title: String) {
        possibleExerciseTitle.text = title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
