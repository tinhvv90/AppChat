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
    @IBOutlet weak var loginRegisterSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var heightContainerViewLayout: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginRegisterSegmentedControl.selectedSegmentIndex = 1
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func handleLogin() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                print("From is not valid")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                print(error)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }

    func handleRegister() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {
                print("From is not valid")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            if let user = authResult?.user {
                // successfully authenticated user
                let ref = Database.database().reference(fromURL: "https://appchat-7b4be.firebaseio.com/")
                let usersReference = ref.child("users").child(user.uid)
                let values = ["name": name, "email": email]
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                print("fail")
            }
        }
    }
    @IBAction func handleLoginRegister(_ sender: UIButton) {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    @IBAction func handleLoginRegisterChange(_ sender: UISegmentedControl) {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        heightContainerViewLayout.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameSeparatorView.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
    }
    
}

