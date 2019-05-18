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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        fetchUser()
    }

    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            print(snapshot)
        }
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }

}
