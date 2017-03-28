//
//  ChatLogController.swift
//  ChatBlink
//
//  Created by Yaroslav on 13/03/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user:User?
   
    //UI Elements
    let containerView:UIView = {
        let cv = UIView()
       // cv.backgroundColor = UIColor.red
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let sendButton:UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Send", for: .normal)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return sb
    }()
    
    lazy var inputTextField:UITextField = {
       let tf = UITextField()
        tf.placeholder = "Enter message..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        return tf
    }()
    
    let lineSeparatorView: UIView = {
        let ls = UIView()
        ls.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        ls.translatesAutoresizingMaskIntoConstraints = false
        return ls
    }()
    ////
    
          
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user?.name
        
        collectionView?.backgroundColor = UIColor.white
        
        view.addSubview(containerView)
        containerView.addSubview(sendButton)
        containerView.addSubview(inputTextField)
        containerView.addSubview(lineSeparatorView)
        setupInputComponetes()
        registerForKeyboardNotifications()
        
                
    }
    
    deinit {
        removeKeabordNotifications()
    }
    
    func removeKeabordNotifications() {
        NotificationCenter.default.removeObserver(self,  name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self,  name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keybordWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keabordFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: keabordFrameSize.height).isActive = true
        
    }
    
    func keybordWillHide() {
          containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupInputComponetes(){
        
        //container position
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //button position
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //inputfield position
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //separator position
        
        lineSeparatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        lineSeparatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        lineSeparatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        lineSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func handleSend() {
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = FIRAuth.auth()?.currentUser?.uid
        let time = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromId!, "time": time] as [String : Any]
        childRef.updateChildValues(values)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}
