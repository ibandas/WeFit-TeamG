//
//  ChallengeAddMemberVC.swift
//  WeFit
//
//  Created by Irinel Bandas on 5/16/20.
//  Copyright © 2020 Irinel Bandas. All rights reserved.
//

import UIKit
import Firebase

class ChallengeAddMemberVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var members: [Member] = []
    var already_members: [Competitor] = []
    var selected_members: [Competitor] = []
    var challenge_id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUsers {
            self.tableView.reloadData()
        }
        print(self.already_members[0].firstName)
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func loadUsers(completion: @escaping () -> ()) {
        let ref = Firestore.firestore().collection("users")
        ref.getDocuments(completion: {(snapshot, error) in
            if error != nil {
                print("Error")
            }
            else {
                guard let snap = snapshot else {return}
                for document in snap.documents {
                    let id = document.documentID
                    if (id == Auth.auth().currentUser!.uid) || (self.already_members.contains(where: {$0.id == id})) {
                        continue
                    }
                    let data = document.data()
                    let firstName = data["firstName"] as! String
                    print(firstName)
                    let lastName = data["lastName"] as! String
                    self.members.append(Member(uid: id, firstName: firstName, lastName: lastName))
                }
            }
            completion()
        })
    }
}

extension ChallengeAddMemberVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memberCell = self.tableView.dequeueReusableCell(withIdentifier: "ChallengeMemberCell", for: indexPath) as!
        ChallengeMemberCell
        memberCell.setName(firstName: members[indexPath.row].firstName, lastName: members[indexPath.row].lastName)
        return memberCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
    }
}
