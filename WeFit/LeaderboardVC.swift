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
    var leaderboard: [Competitor] = []
    var challenges: myChallenges = myChallenges()
    let uid = Auth.auth().currentUser!.uid
    // let myGroup = DispatchGroup()
    let opQueue: OperationQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
//    func createLeaderboard() -> [Competitor] {
//        var tempArray: [Competitor] = [Competitor(name: "Tim", profilePicture: UIImage(named: "pp1")!, points: 50),
//        Competitor(name: "Bob", profilePicture: UIImage(named: "pp1")!, points: 0),
//        Competitor(name: "Sofia", profilePicture: UIImage(named: "pp1")!, points: 30)]
//        tempArray.sort(by: {$0.points > $1.points})
//        return tempArray
//    }
    
//    func loadPartakingChallenges() {
//        self.myGroup.enter()
//        let ref = Firestore.firestore().collection("users/\(self.uid)/partaking_challenges").whereField("active", isEqualTo: true)
//
//            ref.getDocuments(completion: {(snapshot, error) in
//            if error != nil {
//                print("Error")
//            }
//            else {
//                guard let snap = snapshot else {return}
//                for document in snap.documents {
//                    let data = document.data()
//                    let cid = data["challenge_id"] as! String
//                    self.loadChallenge(cid: cid, completion: {challenge in
//                        if let challenge = challenge {
//                            self.challenges.append(challenge)
//                            print(self.challenges)
//                        } else {
//                            return
//                        }
//                    })
//                }
//            }
//        })
//    }
    
//    func loadChallenge(cid: String, completion: @escaping (Challenge?) -> ()) {
//        self.myGroup.enter()
//        let challenge_ref = Firestore.firestore().collection("challenges").document(cid)
//        challenge_ref.getDocument(completion: {(challenge_doc, error) in
//            if let challenge_doc = challenge_doc, challenge_doc.exists {
//                print("Document does exist")
//                let challenge_data = challenge_doc.data()
//                let title = challenge_data!["title"] as? String
//                let created_at_ts = challenge_data!["created_at"] as? Timestamp
//                let ends_at_ts = challenge_data!["ends_at"] as? Timestamp
//                let created_at = created_at_ts!.dateValue() as? Date
//                let ends_at = ends_at_ts!.dateValue() as? Date
//                let group_owner = challenge_data!["group_owner"] as? String
//                let mectric = challenge_data!["mectric"] as? String
//                let members = challenge_data!["members"] as? Array<String>
//
//                completion(Challenge(title: title!, mectric: mectric!, group_owner: group_owner!, group_members: members!, created_at: created_at!, ends_at: ends_at!))
//                self.myGroup.leave()
//
//            } else {
//                print("Document does not exist")
//            }
//        })
//        self.myGroup.leave()
//    }
    
    func setChallengeTitle(title: String) {
        self.challenge_title.text? = title
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
