//
//  PastChallengeTableViewCell.swift
//  WeFit
//
//  Created by Cristina Barclay on 6/9/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

class PastChallengeTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var pointsUser: UILabel!
    @IBOutlet weak var pointsOut: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var challengeTitle: UILabel!
    var indexPath:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
