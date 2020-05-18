//
//  LeaderboardViewController.swift
//  WeFit
//
//  Created by Cristina Barclay on 5/6/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class Leaderboard: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var challenge_title: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var challengeDrop: UIButton!
    
    @IBOutlet weak var challengeTblView: UITableView!
    
    
    var leaderboard: [Competitor] = []
    var challenges: myChallenges = myChallenges()
    var refreshControl = UIRefreshControl()
    let uid = Auth.auth().currentUser!.uid
    let opQueue: OperationQueue = OperationQueue()
    
    @objc func refresh(_ sender: AnyObject) {
        self.challenges.loadChallenges {
            self.setChallengeTitle(title: self.challenges.challenges[0].title)
            self.challenges.challenges[0].sortLeaderboard()
            self.leaderboard = self.challenges.challenges[0].leaderboard
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
            self.refreshControl.endRefreshing()
            for challenge in self.challenges.challenges {
                print(challenge.leaderboard)
            }
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        self.startLoadingAlert()
        self.challenges.loadChallenges {
            self.setChallengeTitle(title: self.challenges.challenges[0].title)
            self.challenges.challenges[0].sortLeaderboard()
            self.leaderboard = self.challenges.challenges[0].leaderboard
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        challengeTblView.isHidden = true
    }
    
    
    @IBAction func onClickDrop(_ sender: Any) {
        if challengeTblView.isHidden{
            animate(toggle: true)
        } else{
            animate(toggle: false)
        }
    }
    
    func animate(toggle: Bool){
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.challengeTblView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.challengeTblView.isHidden = true
            }
        }
    }
    
    func startLoadingAlert() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)

        self.opQueue.addOperation {
            OperationQueue.main.addOperation({
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func setChallengeTitle(title: String) {
        self.challenge_title.text? = title
    }
    
    func setRank(rank: String) {
        self.rank.text? = rank
    }
}

extension Leaderboard: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
        // Total amount of exercises displayed in Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 1
        switch tableView {
        case tableView:
            numberOfRows = leaderboard.count
        case challengeTblView:
            numberOfRows = challenges.challenges.count
        default:
            print("something is wrong")
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case tableView:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath) as! RankCell
            cell.setProfile(competitor: leaderboard[indexPath.row], indexPath: indexPath)
            if leaderboard[indexPath.row].id == self.uid {
                self.setRank(rank: String(indexPath.row + 1))
            }
            return cell
        case challengeTblView:
            let cell = challengeTblView.dequeueReusableCell(withIdentifier: "ChallengeTitleCell", for: indexPath)
            return cell
        default:
            print("something wrong")
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        challengeDrop.setTitle("\(challenges.challenges[indexPath.row].title)", for: .normal)
        animate(toggle: false)
    }
}
