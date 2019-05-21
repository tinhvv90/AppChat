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
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.register(ChatMessageViewCell.self, forCellWithReuseIdentifier: "CellId")
        inputTextField.delegate = self
        setupInputComponents()
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dic = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message()
                message.fromId = dic["fromId"] as? String
                message.text = dic["text"] as? String
                message.toId = dic["toId"] as? String
                message.timestamp = dic["timestamp"] as? NSNumber
                
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
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
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error)
                    return
                }
                
                self.inputTextField.text = nil
                
                if let messageId = childRef.key {
                    let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
                    userMessagesRef.updateChildValues([messageId: 1])
                    
                    let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
                    recipientUserMessagesRef.updateChildValues([messageId: 1])
                }
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

// MARK - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ChatlogController : UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! ChatMessageViewCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        // change with bubbleWith
        if let text = message.text {
            cell.bubbleWithAnchor?.constant = estimateFrameForText(text: text).width + 32
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        // get estimate height from string
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}
