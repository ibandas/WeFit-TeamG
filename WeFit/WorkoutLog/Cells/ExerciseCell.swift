//
//  ExerciseCell.swift
//  WeFit
//
//  Created by Irinel Bandas on 4/25/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

protocol ExerciseCellDelegate {
    func didTapDeleteExerciseButton(cell: ExerciseCell)
}

class ExerciseCell: UITableViewCell {

    @IBOutlet weak var ExerciseTitle: UILabel!
    
    var delegate: ExerciseCellDelegate?
    
    func setExercise(exercise: Exercise) {
        ExerciseTitle.text = exercise.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func DeleteExercise(_ sender: Any) {
        delegate?.didTapDeleteExerciseButton(cell: self)
    }

}
