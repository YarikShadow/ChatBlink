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
    let cellId = "cellId"
    
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
        
//        let swipeToNewMessage = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeToNewMessageController))
//        swipeToNewMessage.direction = .right
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
      //  view.addGestureRecognizer(swipeToNewMessage)
        
        let logoutImage = UIImage(named: "exit")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoutImage, style: .plain, target: self, action: #selector(handleLogout))
     
        tableView.separatorStyle = .singleLine
    
        tableView.separatorInset.left = 25
        tableView.separatorInset.right = 25
        
        
        
       
        let image = UIImage(named: "smallIcon")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image , style: .plain, target: self, action: #selector(handleNewMessage))
        
        sideBar = SideBar(sourceView: self.view, menuItems:["Day", "Night"])
        sideBar.delegate = self
        
        
        checkIfUserLoggedIn()
        fetchUser()
        observeMessages()
        
       
    }
    
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                 handleNewMessage()
            case UISwipeGestureRecognizerDirection.down:
                 handleNewMessage()
            case UISwipeGestureRecognizerDirection.left:
                 handleNewMessage()
            case UISwipeGestureRecognizerDirection.up:
                 handleNewMessage()
            default:
                break
            }
        }
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
        return 56
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        
        self.messages.sort(by: { Int($0.time!) > Int($1.time!) })
        let messages =  self.messages[indexPath.row]
        
        
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
        }, completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })

        cell.contentMode = .center
        cell.imageView?.image = UIImage(named: "user")
        cell.imageView?.layer.masksToBounds = true
        
        if let toId = messages.toId {
            let ref  = FIRDatabase.database().reference().child("users").child(toId)
            ref.observe(.value, with: { (snapshot) in
                    
            if let dictionary = snapshot.value as? [String: AnyObject] {
               
                    let names  = dictionary["name"] as? String
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let date = NSDate(timeIntervalSince1970: TimeInterval(messages.time!))
                    cell.detailTextLabel?.text = "From: \(names!) : \(formatter.string(from: date as Date))"
                
                
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                    
                    cell.imageView?.loadImageUsingCache(urlString: profileImageUrl)
                    cell.imageView?.layer.cornerRadius = 15
                }
                

                
                
                }
            }
            , withCancel: nil)
           
        }
        
        
        cell.textLabel?.text = messages.text
        cell.textLabel?.textColor = UIColor(red: 81.0 / 255.0, green: 74.0 / 255.0, blue: 157.0 / 255.0, alpha: 1.0)
        
        
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.view.window!.layer.add(transition, forKey: nil)
//        dismiss(animated: false, completion: {
//            let user = self.users[indexPath.row]
//            self.showChatController(user: user)
//            print("dismiss completed")
//        })
//    }


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

