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
    
    @IBAction func addMembers(_ sender: Any) {
        print("Navigated")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ChallengeAddMemberVC
        {
            let vc = segue.destination as? ChallengeAddMemberVC
            vc?.challenge_id = challenges.challenges[0].challenge_id
            vc?.already_members = leaderboard
        }
    }
    
    @IBAction func unwindFromChallengeAddMembers(_ sender: UIStoryboardSegue) {
        if sender.source is ChallengeAddMemberVC {
            if let senderVC = sender.source as? ChallengeAddMemberVC {
                let challenge_ref = Firestore.firestore().collection("challenges").document(senderVC.challenge_id)
                    let cells = senderVC.tableView.visibleCells as! [ChallengeMemberCell]
                    for cell in cells {
                        if(cell.accessoryType == UITableViewCell.AccessoryType.checkmark) {
                            let indexPath = senderVC.tableView.indexPath(for: cell)
                            let uid: String = senderVC.members[indexPath!.row].uid
                            let firstName: String = senderVC.members[indexPath!.row].firstName
                            let lastName: String = senderVC.members[indexPath!.row].lastName
                            let points: Int = 0
                            let newMember: Dictionary<String, Any> = ["firstName": firstName,
                                                                      "lastName": lastName,
                                                                      "points": points]
                            challenge_ref.updateData(["scores.\(uid)": newMember,
                                                      "members": FieldValue.arrayUnion([uid])])
                        }
                    }
                }
            }
        }
    
    
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
        return leaderboard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rankCell = self.tableView.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath) as! RankCell
        rankCell.setProfile(competitor: leaderboard[indexPath.row], indexPath: indexPath)
        if leaderboard[indexPath.row].id == self.uid {
            self.setRank(rank: String(indexPath.row + 1))
        }
        return rankCell
    }
}
