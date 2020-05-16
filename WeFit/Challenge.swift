//
//  Challenge.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/11/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import Firebase
import UIKit

struct Challenge {
    var challenge_id: String
    var title: String = ""
    var exercise: String = ""
    var mectric: String = "reps"
    var group_owner: String = ""
    var group_members: [String]
    var leaderboard: [Competitor] = []
    var created_at: Date = Date()
    var ends_at: Date = Date()
    
    mutating func sortLeaderboard() {
        self.leaderboard.sort(by: {$0.points > $1.points})
    }
}

class myChallenges {
    let uid: String = Auth.auth().currentUser!.uid
    let myGroup: DispatchGroup = DispatchGroup()
    var challenges: [Challenge] = []
    
    
    func loadChallenges(completion: @escaping () -> ()) {
        var challenge_results: [Challenge] = []
        let ref = Firestore.firestore().collection("challenges").whereField("active", isEqualTo: true).whereField("members", arrayContains: self.uid)
        ref.getDocuments(completion: {(snapshot, error) in
            if error != nil {
                print("Error")
            }
            else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let data = document.data()
                    let challenge_id = document.documentID as? String
                    let title = data["title"] as? String
                    let created_at_ts = data["created_at"] as? Timestamp
                    let ends_at_ts = data["ends_at"] as? Timestamp
                    let created_at = created_at_ts!.dateValue() as Date
                    let ends_at = ends_at_ts!.dateValue() as Date
                    let group_owner = data["group_owner"] as? String
                    let mectric = data["mectric"] as? String
                    let exercise = data["exercise"] as? String
                    let scores = data["scores"] as? Dictionary<String, Dictionary<String, Any>>
                    let members = data["members"] as? Array<String>
                    var competitors: [Competitor] = []
                    for (key, value) in scores! {
                        let firstName = value["firstName"] as? String
                        let lastName = value["lastName"] as? String
                        let points = value["points"] as? Int
                        let competitor = Competitor(id: key, firstName: firstName!, lastName: lastName!, points: points!)
                        competitors.append(competitor)
                    }
                    let challenge = Challenge(challenge_id: challenge_id!, title: title!, exercise: exercise!, mectric: mectric!, group_owner: group_owner!, group_members: members!, leaderboard: competitors, created_at: created_at, ends_at: ends_at)
                    challenge_results.append(challenge)
                }
                self.challenges = challenge_results
                completion()
            }
        })
    }
}
