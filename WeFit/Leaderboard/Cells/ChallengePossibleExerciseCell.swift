//
//  ChallengePossibleExerciseCell.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/19/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

protocol ChallengePossibleExerciseCellDelegate {
    func didTapAddButtonAction(cell: ChallengePossibleExerciseCell)
    func updateGoalAmount(cell: ChallengePossibleExerciseCell)
}

class ChallengePossibleExerciseCell: UITableViewCell {
    
    @IBOutlet weak var exerciseTitle: UILabel!
    @IBOutlet weak var goalAmountInput: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func goalAmountButton(_ sender: Any) {
        delegate?.updateGoalAmount(cell: self)
    }
    
    var delegate: ChallengePossibleExerciseCellDelegate?
    var added: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.tintColor = UIColor.green
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setExerciseTitle(title: String) {
        self.exerciseTitle?.text = title
    }
    
    func setGoalAmount(goal: Int) {
        self.goalAmountInput?.text = String(goal)
    }
    
    func setAddButton(added: Bool) {
        if added {
            addButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
            addButton.tintColor = UIColor.red
        }
        else {
            addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            addButton.tintColor = UIColor.green
        }
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        delegate?.didTapAddButtonAction(cell: self)
        if self.added {
            addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            addButton.tintColor = UIColor.green
            self.added = false
        } else {
            addButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
            addButton.tintColor = UIColor.red
            self.added = true
        }
    }
}
