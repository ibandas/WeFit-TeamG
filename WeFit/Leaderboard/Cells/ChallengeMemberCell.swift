//
//  ChallengeMemberCell.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/16/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit



class ChallengeMemberCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    func setName(firstName: String, lastName: String) {
        self.name.text = "\(firstName) \(lastName)"
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
