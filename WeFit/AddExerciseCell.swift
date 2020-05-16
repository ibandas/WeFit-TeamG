//
//  AddExerciseCell.swift
//  WeFit
//
//  Created by Irinel Bandas on 4/27/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

protocol AddExerciseCellDelegate {
    func didTapExercisesButton(cell: AddExerciseCell)
}


class AddExerciseCell: UITableViewCell {
    
    var delegate: AddExerciseCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func AddExercisesButton(_ sender: Any) {
        delegate?.didTapExercisesButton(cell: self)
    }

}
