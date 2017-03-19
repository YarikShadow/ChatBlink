//
//  UserCell.swift
//  ChatBlink
//
//  Created by Admin on 19/03/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
                textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
                detailTextLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y + 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
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
        
                    profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
                    profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                    profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
                   profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


