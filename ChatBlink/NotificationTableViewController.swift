//
//  NotificationTableViewController.swift
//  ChatBlink
//
//  Created by Yarolsav on 15/03/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationTableViewController: UITableViewController {
    
    //Notifications
//    let content:UNMutableNotificationContent = {
//        let ct = UNMutableNotificationContent()
////        ct.title = "lalka"
////        ct.subtitle = "loool"
////        ct.body = "ggggggg"
//        ct.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
//        ct.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
//        ct.sound = UNNotificationSound.default()
//        ct.badge = UIApplication.shared.applicationIconBadgeNumber as NSNumber?
//        
//        return ct
//    }()
//    
//    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//    
//    let request = UNNotificationRequest(identifier: "FiveSeconds", content: self.content, trigger: trigger)
//    
//    ////
//
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
            }
    
    func requestUserAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {
            (granted, error) in
            if granted {
                self.loadNotificationData()
            } else {
                print(error?.localizedDescription as Any)
            }})
     }
    
    func loadNotificationData() {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
        content.sound = UNNotificationSound.default()
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if error != nil {
                // Handle any errors
            }
        }

//        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
//            if let error = error {
//                print(error)
//                completion(false)
//            } else {
//                completion(true)
//            }
//        })

    }

   }
