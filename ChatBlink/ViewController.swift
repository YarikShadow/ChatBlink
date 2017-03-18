//
//  ViewController.swift
//  ChatBlink
//
//  Created by Yaroslav on 28/02/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController, SideBarDelegate {
    
    var sideBar:SideBar = SideBar()
    var users = [User]()
    var messages = [Message]()
    
    let transition: CATransition = { // animation for view transition
        let tr = CATransition()
        tr.duration = 0.5
        tr.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        tr.type = kCATransitionReveal
        tr.subtype = kCATransitionFromRight
        return tr
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutImage = UIImage(named: "exit")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoutImage, style: .plain, target: self, action: #selector(handleLogout))
        
        
       
        let image = UIImage(named: "smallIcon")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image , style: .plain, target: self, action: #selector(handleNewMessage))
        
        sideBar = SideBar(sourceView: self.view, menuItems:["Day", "Night"])
        sideBar.delegate = self
        
        checkIfUserLoggedIn()
        observeMessages()
        fetchUser()
       
    }
    
    
    // Load data from Firebase
    func observeMessages() {
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observe(.childAdded, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
            let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                
            }
        }, withCancel: nil)
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeys(dictionary) // Safe way -  user.name = dictionary["name"]
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            
            
        }, withCancel: nil)
    
    }
    ////end
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
       
        cell.imageView?.image = UIImage(named: "user")
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.cornerRadius = 5
       
        let messages =  self.messages[indexPath.row]
        let user = users[indexPath.row]
        if let toId = messages.toId {
            let ref  = FIRDatabase.database().reference().child("users").child(toId)
            ref.observe(.value, with: { (snapshot) in
                    
            if let dictionary = snapshot.value as? [String: AnyObject] {
               
                cell.textLabel?.text = dictionary["name"] as? String
                }
            }
            , withCancel: nil)
           
        }
        
        
        if let profileImageUrl = user.profileImageUrl {
            
            
            cell.imageView?.loadImageUsingCache(urlString: profileImageUrl)
        }
        
        cell.detailTextLabel?.text = messages.text
        
        return cell
    }

    func checkIfUserLoggedIn() {
        
        //if user isn't logged
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            //if user logged in
            fetchUserAndSetupNavBar()
        }
    }
    
    func fetchUserAndSetupNavBar() {
       
        guard let uid = FIRAuth.auth()?.currentUser?.uid  else {
            //for some reason uid is nil
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                
                self.navigationItem.title = dictionary["name"] as? String
            }
        }, withCancel: nil)
        
        
       
        //add tap action
//        self.navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    func showChatController(user: User){
    
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogController.user = user
            navigationController?.pushViewController(chatLogController, animated: false)
    }
    
    func handleLogout(){
        
        do {
           try  FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        loginController.messageController = self
        
        transition.subtype = kCATransitionFromLeft
      self.view.window!.layer.add(transition, forKey: nil)
      present(loginController, animated: false, completion: nil)
        
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messageController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        self.view.window!.layer.add(transition, forKey: nil)
        present(navController, animated: false, completion: nil)
    }
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        
        
        switch index {
        case 0 :
                view.backgroundColor = UIColor.white
                sideBar.showSideBar(shouldOpen: false)
        case 1 :
                view.backgroundColor = UIColor.black
                sideBar.showSideBar(shouldOpen: false)
            
        default : break
        }
    }

}

