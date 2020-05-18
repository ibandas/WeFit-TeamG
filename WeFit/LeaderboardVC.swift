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
    
    
    @IBOutlet weak var leaderboardTblView: UITableView!
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
            self.challenges.challenges[0].sortLeaderboard()
            self.leaderboard = self.challenges.challenges[0].leaderboard
            self.leaderboardTblView.reloadData()
            self.challengeTblView.reloadData()
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
        self.leaderboardTblView.addSubview(refreshControl)
        self.startLoadingAlert()
        self.challenges.loadChallenges {
            self.challenges.challenges[0].sortLeaderboard()
            self.leaderboard = self.challenges.challenges[0].leaderboard
            self.leaderboardTblView.reloadData()
            self.challengeTblView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        self.leaderboardTblView.delegate = self
        self.leaderboardTblView.dataSource = self
        self.challengeTblView.delegate = self
        self.challengeTblView.dataSource = self
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

    
    func setRank(rank: String) {
        self.rank.text? = rank
    }
    
    func loadChallenge(selectedIndex: Int){
        
        self.challenges.challenges[selectedIndex].sortLeaderboard()
        self.leaderboard = self.challenges.challenges[selectedIndex].leaderboard
            
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
        case leaderboardTblView:
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
        case leaderboardTblView:
            let cell = self.leaderboardTblView.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath) as! RankCell
            cell.setProfile(competitor: leaderboard[indexPath.row], indexPath: indexPath)
            if leaderboard[indexPath.row].id == self.uid {
                self.setRank(rank: String(indexPath.row + 1))
            }
            return cell
        case challengeTblView:
            let cell = self.challengeTblView.dequeueReusableCell(withIdentifier: "ChallengeTitleCell", for: indexPath)
            cell.textLabel?.text = challenges.challenges[indexPath.row].title
            return cell
        default:
            print("something wrong")
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.challengeTblView {
            var selectedChallenge = indexPath.row
            challengeDrop.setTitle("  \(challenges.challenges[indexPath.row].title)", for: .normal)
            animate(toggle: false)
            
            loadChallenge(selectedIndex: selectedChallenge)
        }
    }
}
