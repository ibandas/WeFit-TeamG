//
//  LeaderboardViewController.swift
//  WeFit
//
//  Created by Cristina Barclay on 5/6/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import UIKit


class Leaderboard: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var leaderboard: [Competitor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leaderboard = createLeaderboard()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func createLeaderboard() -> [Competitor] {
        var tempArray: [Competitor] = [Competitor(name: "Tim", profilePicture: UIImage(named: "pp1")!, points: 50),
        Competitor(name: "Bob", profilePicture: UIImage(named: "pp1")!, points: 0),
        Competitor(name: "Sofia", profilePicture: UIImage(named: "pp1")!, points: 30)]
        tempArray.sort(by: {$0.points > $1.points})
        return tempArray
    }
}

extension Leaderboard: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
        // Total amount of exercises displayed in Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rankCell = self.tableView.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath) as! RankCell
        rankCell.setProfile(competitor: leaderboard[indexPath.row], indexPath: indexPath)
        return rankCell
    }
}
