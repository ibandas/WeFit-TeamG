//
//  Challenge.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/11/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

struct Challenge {
    var challenge_id: String = ""
    var title: String = ""
    var exercises: [String] = []
    var mectric: String = "reps"
    var group_owner: String = ""
    var group_members: [String] = []
    var leaderboard: [Competitor] = []
    var created_at: Date = Date()
    var ends_at: Date = Date()
    var days_remaining: Int = 0
    var totalGoal: Int = 0
    var loaded: Bool = false
    
    mutating func sortLeaderboard() {
        self.leaderboard.sort(by: {$0.points > $1.points})
    }
    
    mutating func calculateDaysRemaining() {
        self.days_remaining = Calendar.current.dateComponents([.day], from: self.created_at, to: self.ends_at).day!
    }
}

class myChallenges {
    let uid: String = User.sharedGlobal.uid
    let myGroup = DispatchGroup()
    var challenges: [Challenge] = []
    
    
    func loadChallenges(completion: @escaping () -> ()) {
        self.myGroup.enter()
        var challenge_results: [Challenge] = []
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let start = Calendar.current.date(from: components)!
        let ref = Firestore.firestore().collection("challenges").whereField("members", arrayContains: self.uid).whereField("ends_at", isGreaterThanOrEqualTo: start).order(by: "ends_at")
        ref.getDocuments(completion: {(snapshot, error) in
            if error != nil {
                print("Error: \(error)")
            }
            else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    self.myGroup.enter()
                    let data = document.data()
                    let challenge_id = document.documentID
                    let title = data["title"] as? String
                    let created_at_ts = data["created_at"] as? Timestamp
                    let ends_at_ts = data["ends_at"] as? Timestamp
                    let created_at = created_at_ts!.dateValue() as Date
                    let ends_at = ends_at_ts!.dateValue() as Date
                    let group_owner = data["group_owner"] as? String
                    let mectric = data["mectric"] as? String
                    let exercises = data["exercises"] as? [String]
                    let scores = data["scores"] as? Dictionary<String, Dictionary<String, Any>>
                    let members = data["members"] as? Array<String>
                    let totalGoal = data["totalGoal"] as? Int
                    var competitors: [Competitor] = []
                    for (key, value) in scores! {
                        let firstName = value["firstName"] as? String
                        let lastName = value["lastName"] as? String
                        let points = value["points"] as? Int
                        var competitor = Competitor(id: key, firstName: firstName!, lastName: lastName!, points: points!)
                        competitors.append(competitor)
                    }
                    var challenge = Challenge(challenge_id: challenge_id, title: title!, exercises: exercises!, mectric: mectric!, group_owner: group_owner!, group_members: members!, leaderboard: competitors, created_at: created_at, ends_at: ends_at, totalGoal: totalGoal!)
                    challenge.calculateDaysRemaining()
                    challenge_results.append(challenge)
                    self.myGroup.leave()
                }
                self.myGroup.leave()
                self.myGroup.notify(queue: .main) {
                    self.challenges = challenge_results
                    completion()
                }
            }
        })
    }
}

extension CollectionReference {
    func whereField(_ field: String, isDateLess value: Date) -> Query {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
        guard
            let start = Calendar.current.date(from: components),
            let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
        else {
            fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isLessThanOrEqualTo: end)
    }
}
