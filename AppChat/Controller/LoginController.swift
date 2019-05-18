//
//  LoginController.swift
//  AppChat
//
//  Created by CenHomes on 5/18/19.
//  Copyright © 2019 Simson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {

    @IBOutlet weak var inputsContainerView: UIView!
    
    @IBOutlet weak var nameSeparatorView: UIView!
    @IBOutlet weak var emailSeparatorView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func handleRegister(_ sender: UIButton) {
        
        print(123)
    }
}

