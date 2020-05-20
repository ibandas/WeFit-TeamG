//
//  AddSetCell.swift
//  WeFit
//
//  Created by Irinel Bandas on 4/27/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

protocol AddSetCellDelegate {
    func didTapAddSetButton(cell: AddSetCell)
}

class AddSetCell: UITableViewCell {
    
    var delegate: AddSetCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func AddSetButton(_ sender: Any) {
        delegate?.didTapAddSetButton(cell: self)
    }
}

