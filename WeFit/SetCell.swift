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
    
    @IBAction func weightTextFieldUpdated(_ sender: Any) {
        delegate?.updateWeight(cell: self)
    }
    
    @IBAction func repsTextFieldUpdated(_ sender: Any) {
        delegate?.updateReps(cell: self)
    }
    
    func setSets(set: Set) {
        WeightEntry.text = String(set.weight)
        RepEntry.text = String(set.reps)
    }
    
    func setWeight(weight: Int) {
        WeightEntry.text = String(weight)
    }
    
    func setReps(reps: Int) {
        RepEntry.text = String(reps)
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
