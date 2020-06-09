//
//  PastChallengeCell.swift
//  WeFit
//
//  Created by Cristina Barclay on 6/2/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import UIKit

class PastChallengeCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var pointsOutOf: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        func setName(name: String) {
            self.name.text = name
        }
    
        func setRank(rank: Int) {
            self.rank.text = String(rank)
        }
    
        func setPoints(points: Int) {
            self.points.text = String(points)
        }
    
        func setPointsOutOf(pointsOutOf: Int) {
            self.pointsOutOf.text = String(pointsOutOf)
        }
        
    func setPastChallenge(challenge: Challenge, uid: String, indexPath: IndexPath) {
        self.setName(name: challenge.title)
        let user_id: String = challenge.leaderboard[indexPath.row].id
        if user_id == uid {
            self.setRank(rank: indexPath.row + 1)
            self.setPoints(points: challenge.leaderboard[indexPath.row].points )
        }
        self.setPointsOutOf(pointsOutOf: challenge.totalGoal)
        self.setRank(rank: indexPath.row + 1)
        }
    
    
}
