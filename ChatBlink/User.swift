//
//  User.swift
//  ChatBlink
//
//  Created by Yaroslav on 01/03/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageUrl: String?
    
    static var currentUser = User()
    
    func setUser(_ json: JSON) {
        self.name = json["name"].string
        if json["email"].string != nil {
            self.email = json["email"].string
        } else {
            self.email = "undefined@gmail.com"
        }
        
        if let image = json["picture"].dictionary {
            if let imageData = image["data"]?.dictionary {
                self.profileImageUrl = imageData["url"]?.string
            }
        }
    }
    
    func resetUser() {
        self.name = nil
        self.email = nil
        self.profileImageUrl = nil
    }
}
