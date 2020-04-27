//
//  SetCell.swift
//  WeFit
//
//  Created by Irinel Bandas on 4/26/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

class SetCell: UITableViewCell {
    
    

    @IBOutlet weak var WeightLabel: UILabel!
    @IBOutlet weak var RepLabel: UILabel!
    
    @IBOutlet weak var WeightEntry: UITextField!
    @IBOutlet weak var RepEntry: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
