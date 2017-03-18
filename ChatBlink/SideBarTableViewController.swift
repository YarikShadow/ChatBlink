//
//  SideBarTableViewController.swift
//  ChatBlink
//
//  Created by Yaroslav on 10/03/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit


protocol sideBarTableViewControllerDelegate {
    func sideBarControlDidSelectRow(indexPath: IndexPath)
}

class SideBarTableViewController: UITableViewController {
    
    var delegate: sideBarTableViewControllerDelegate?
    var tableData:[String]!
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.textColor = UIColor.darkText
            
            let selectedView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
            cell!.selectedBackgroundView = selectedView
        }
        
        
        cell?.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
            UIView.animate(withDuration: 0.3, animations: { cell?.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1) }, completion: { finished in
                
                        UIView.animate(withDuration: 0.1, animations: {
                            cell?.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
        
        cell?.textLabel?.frame = (cell?.bounds)!
        cell!.textLabel?.text = tableData[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sideBarControlDidSelectRow(indexPath: indexPath)
    }
    
    
    
}
