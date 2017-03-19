//
//  NewMessageController.swift
//  ChatBlink
//
//  Created by Yaroslav on 01/03/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()
    var messageController:ViewController?
    
    let transition: CATransition = { // animation for view transition
        let tr = CATransition()
        tr.duration = 0.5
        tr.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        tr.type = kCATransitionReveal
        tr.subtype = kCATransitionFromLeft
        return tr
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
       // tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
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
    
    func handleCancel() {
        self.view.window!.layer.add(transition, forKey: nil)
        dismiss(animated: false, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) //as! UserCell
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        
        let user = users[indexPath.row]
        
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
        }, completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })

        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.detailTextLabel?.textColor = UIColor(red: 81.0 / 255.0, green: 74.0 / 255.0, blue: 157.0 / 255.0, alpha: 1.0)
        cell.imageView?.image = UIImage(named: "user")
        cell.imageView?.layer.masksToBounds = true
        
        
        
        //load profileIamges from cashe
        if let profileImageUrl = user.profileImageUrl {
            
            
            cell.imageView?.loadImageUsingCache(urlString: profileImageUrl)
            cell.imageView?.layer.cornerRadius = 15
            
//            let url = URLRequest(url: URL(string: profileImageUrl)!)
//            URLSession.shared.dataTask(with: url) {
//                (data, response, error) in
//                if error != nil {
//                    print(error!)
//                    return
//                }
//                DispatchQueue.main.async {
//                   cell.profileImageView.image = UIImage(data: data!)
//                    cell.imageView?.image = UIImage(data: data!)
//                }
//            }.resume()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.window!.layer.add(transition, forKey: nil)
        dismiss(animated: false, completion: {
            let user = self.users[indexPath.row]
            self.messageController?.showChatController(user: user)
            print("dismiss completed")
        })
    }
    
}
