//
//  ViewController.swift
//  ChatBlink
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
               let logoutIamge = UIImage(named: "exit")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoutIamge, style: .plain, target: self, action: #selector(handleLogout))
        
       
        let image = UIImage(named: "smallIcon")
        
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: image , style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserLoggedIn()
       
    }

    func checkIfUserLoggedIn() {
        
        //if user isn't logged
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            //if user logged in
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            }, withCancel: nil)
        }
    }
    
    func handleLogout(){
        
        do {
           try  FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        
      present(loginController, animated: true, completion: nil)
        
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
}

