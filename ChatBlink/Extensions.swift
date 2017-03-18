//
//  Extentions.swift
//  ChatBlink
//
//  Created by Yaroslav on 05/03/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(urlString:String) {
        
        self.image = nil
        
        //check cache
        if let cachedIamge = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedIamge
            return
        }
        
        //download profileImages
        let url = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let downoadedImage = UIImage(data: data!){
                    imageCache.setObject(downoadedImage, forKey: urlString as AnyObject)
                    self.image = downoadedImage
                }
            }
        }.resume()
    }
}

