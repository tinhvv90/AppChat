//
//  ChatlogController.swift
//  AppChat
//
//  Created by CenHomes on 5/20/19.
//  Copyright © 2019 Simson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ChatlogController: UICollectionViewController {

    var user : User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
        setupInputComponents()
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true

        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorlineView = UIView()
        separatorlineView.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        separatorlineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorlineView)
        
        separatorlineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorlineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorlineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func handleSend() {
        let ref = Database.database().reference().child("messages")
        if let inputText = inputTextField.text {
            
            let childRef = ref.childByAutoId()
            
            let fromId = Auth.auth().currentUser!.uid
            let toId = user!.id!
            let timestamp = Int(Date().timeIntervalSince1970)
            let values = ["text": inputText,
                          "toId": toId,
                          "fromId": fromId,
                          "timestamp": timestamp] as [String : AnyObject]
//            childRef.updateChildValues(values)
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error)
                    return
                }
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
                let messageId = childRef.key
                userMessagesRef.updateChildValues([messageId: 1])
            }
        }
    }
}

extension ChatlogController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
