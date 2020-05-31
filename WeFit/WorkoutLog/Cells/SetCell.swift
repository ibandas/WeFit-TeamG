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
    func updateChallenge(cell: SetCell, completion: @escaping () -> ())
    func updateCompletion(cell: SetCell)
}

class SetCell: UITableViewCell {
    
    var delegate: SetCellDelegate?
    var completed: Bool = false

    @IBOutlet weak var WeightLabel: UILabel!
    @IBOutlet weak var RepLabel: UILabel!
    
    @IBOutlet weak var checkmarkButton: UIButton!
    @IBOutlet weak var WeightEntry: UITextField!
    @IBOutlet weak var RepEntry: UITextField!
    @IBAction func checkmarkButton(_ sender: Any) {
        if self.completed {
            self.delegate?.updateChallenge(cell: self) {
                self.completed = false
                self.delegate?.updateCompletion(cell: self)
            }
            checkmarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            checkmarkButton.tintColor = UIColor.gray
        } else {
            self.delegate?.updateChallenge(cell: self) {
                self.completed = true
                self.delegate?.updateCompletion(cell: self)
            }
            checkmarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkmarkButton.tintColor = UIColor.blue
        }
    }
    
    @IBAction func weightTextFieldUpdated(_ sender: Any) {
        delegate?.updateWeight(cell: self)
    }
    
    @IBAction func repsTextFieldUpdated(_ sender: Any) {
        delegate?.updateReps(cell: self)
    }
    
    func setSets(set: Exercise_Set) {
        WeightEntry.text = String(set.weight)
        RepEntry.text = String(set.reps)
    }
    
    func setWeight(weight: Int) {
        WeightEntry.text = String(weight)
    }
    
    func setReps(reps: Int) {
        RepEntry.text = String(reps)
    }
    
    func setCompletion(completion: Bool) {
        self.completed = completion
        if self.completed {
            checkmarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkmarkButton.tintColor = UIColor.blue
        } else {
            checkmarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            checkmarkButton.tintColor = UIColor.gray
        }
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
