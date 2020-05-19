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
import FirebaseStorage


class Leaderboard: UIViewController {
    
    
    @IBOutlet weak var leaderboardTblView: UITableView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var daysLeft: UILabel!
    
    @IBAction func addMembers(_ sender: Any) {
        print("Navigated")
    }
    @IBOutlet weak var challengeDrop: UIButton!
    
    @IBOutlet weak var challengeTblView: UITableView!
    
    
    var leaderboard: [Competitor] = []
    var challenges: myChallenges = myChallenges()
    let myGroup = DispatchGroup()
    var refreshControl = UIRefreshControl()
    let uid = Auth.auth().currentUser!.uid
    let opQueue: OperationQueue = OperationQueue()
    
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
    
    @objc func refresh(_ sender: AnyObject) {
        let methodStart = Date()
        self.challenges.loadChallenges {
            self.challenges.challenges[0].sortLeaderboard()
            self.leaderboard = self.challenges.challenges[0].leaderboard
            self.loadCompetitors(index: 0) {
                self.leaderboardTblView.reloadData()
                self.challengeTblView.reloadData()
                self.dismiss(animated: true, completion: nil)
                self.refreshControl.endRefreshing()
                let methodFinish = Date()
                let executionTime = methodFinish.timeIntervalSince(methodStart)
                print("Execution time: \(executionTime)")
            }
       }
    }
    
    override func viewDidLoad() {
        let methodStart = Date()
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.leaderboardTblView.addSubview(refreshControl)
        self.startLoadingAlert()
        self.challenges.loadChallenges {
            print(self.uid)
            self.challenges.challenges[0].sortLeaderboard()
            self.leaderboard = self.challenges.challenges[0].leaderboard
            let daysRemaining = self.daysBetween(start: self.challenges.challenges[0].created_at, end: self.challenges.challenges[0].ends_at)
            self.setDaysLeft(days: daysRemaining)
            self.loadCompetitors(index: 0) {
                self.leaderboardTblView.reloadData()
                self.challengeTblView.reloadData()
                self.dismiss(animated: true, completion: nil)
                let methodFinish = Date()
                let executionTime = methodFinish.timeIntervalSince(methodStart)
                print("Execution time: \(executionTime)")
            }
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
    
    func loadCompetitors(index: Int, completion: @escaping () -> ()) {
        self.myGroup.enter()
        for competitor in self.challenges.challenges[index].leaderboard {
            self.myGroup.enter()
            let storageRef = Storage.storage().reference().child("profile/\(competitor.id).jpg")
            storageRef.downloadURL(completion: {(url, error) in
                do {
                    print("Competitor: \(competitor.firstName)")
                    if url != nil {
                        let data = try Data(contentsOf: url!)
                        let result = UIImage(data: data as Data)!
                        competitor.profilePicture = result
                    }
                    self.myGroup.leave()
                } catch {
                    print("error")
                }
            })
        }
        self.myGroup.leave()
        self.myGroup.notify(queue: .main) {
            completion()
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
    
    func setDaysLeft(days: Int){
        self.daysLeft.text? = String(days)
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    
    func loadChallenge(selectedIndex: Int){
        let methodStart = Date()
        self.challenges.challenges[selectedIndex].sortLeaderboard()
        self.leaderboard = self.challenges.challenges[selectedIndex].leaderboard
        let daysRemaining = daysBetween(start: self.challenges.challenges[selectedIndex].created_at, end: self.challenges.challenges[selectedIndex].ends_at)
        self.setDaysLeft(days: daysRemaining)
        self.startLoadingAlert()
        self.loadCompetitors(index: selectedIndex) {
            self.leaderboardTblView.reloadData()
            self.challengeTblView.reloadData()
            self.dismiss(animated: true, completion: nil)
            let methodFinish = Date()
            let executionTime = methodFinish.timeIntervalSince(methodStart)
            print("Execution time: \(executionTime)")
        }
            
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
            let selectedChallenge = indexPath.row
            challengeDrop.setTitle("  \(challenges.challenges[indexPath.row].title)", for: .normal)
            animate(toggle: false)
            
            loadChallenge(selectedIndex: selectedChallenge)
        }
    }
}
