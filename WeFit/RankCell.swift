//
//  RankCell.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/11/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit

class RankCell: UITableViewCell {
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var points: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRank(rank: Int) {
        self.rank.text = String(rank)
    }
    
    func setProfilePicture(pp: UIImage) {
        self.profilePicture.image = pp
    }
    
    func setName(name: String) {
        self.name.text = name
    }
    
    func setPoints(points: Int) {
        self.points.text = String(points)
    }
    
    func setProfile(competitor: Competitor, indexPath: IndexPath) {
        self.setName(name: competitor.name)
        self.setPoints(points: competitor.points)
        self.setProfilePicture(pp: competitor.profilePicture)
        self.setRank(rank: indexPath.row + 1)
    }
}
