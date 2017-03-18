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
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
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
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) //as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        cell.imageView?.image = UIImage(named: "user")
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.cornerRadius = 5
        
        
        //load profileIamges from cashe
        if let profileImageUrl = user.profileImageUrl {
            
            
            cell.imageView?.loadImageUsingCache(urlString: profileImageUrl)
            
            
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
        dismiss(animated: true, completion: {
            let user = self.users[indexPath.row]
            self.messageController?.showChatController(user: user)
            print("dismiss completed")
        })
    }
    
class UserCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
//        detailTextLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y + 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
    }
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
        override init(style: UITableViewCellStyle, reuseIdentifier: String?){
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            
            addSubview(profileImageView)
            
//            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
//            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//            profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//            profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
   
}
