//
//  NewMessageController.swift
//  AppChat
//
//  Created by CenHomes on 5/18/19.
//  Copyright © 2019 Simson. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewMessageController: UITableViewController {

    var users = [User]()
    
    var messagesController: MessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Messages"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        fetchUser()
    }

    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            if let dic = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                user.email = dic["email"] as? String
                user.name = dic["name"] as? String
                user.profileImageUrl = dic["profileImageUrl"] as? String
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user: user)
        }
    }
}
