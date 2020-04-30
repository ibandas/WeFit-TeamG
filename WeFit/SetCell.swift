//
//  SetCell.swift
//  WeFit
//
//  Created by Irinel Bandas on 4/26/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

protocol SetCellDelegate {
    func updateWeight(cell: SetCell)
    func updateReps(cell: SetCell)
}

class SetCell: UITableViewCell {
    
    var delegate: SetCellDelegate?

    @IBOutlet weak var WeightLabel: UILabel!
    @IBOutlet weak var RepLabel: UILabel!
    
    @IBOutlet weak var WeightEntry: UITextField!
    @IBOutlet weak var RepEntry: UITextField!
    
    func setSets(set: Set) {
        WeightEntry.text = String(set.weight)
        RepEntry.text = String(set.reps)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @IBAction func AddSetButton(_ sender: Any) {
//        delegate?.SetCellDelegate(cell: self)
//    }

}
