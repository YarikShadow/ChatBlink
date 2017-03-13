//
//  ViewController.swift
//  ChatBlink
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController, SideBarDelegate {
    
    var sideBar:SideBar = SideBar()

    
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

