//
//  ViewController.swift
//  AppChat
//
//  Created by CenHomes on 5/18/19.
//  Copyright © 2019 Simson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let ref = Database.database().reference(fromURL: "https://appchat-7b4be.firebaseio.com/")
//        ref.updateChildValues(["someValue":123])
//
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }

    @objc func handleLogout() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let loginController = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        present(loginController, animated: true, completion: nil)
    }

}

