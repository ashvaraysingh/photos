//
//  AsyncImageView.swift
//  Photos
//
//  Created by Ashvarya Singh on 29/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, UIImage>()

class AsyncImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImage(urlString: String, placeholder: UIImage, completion: (() -> Void)? = nil) {
        imageUrlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let imageString = imageUrlString, imageString.count > 0, let url = URL.init(string: imageString) {
            self.image = nil
            if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
                self.image = imageFromCache
                completion?()
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let er = error {
                    Log.error(er.localizedDescription)
                     DispatchQueue.main.async {
                      self.image = placeholder
                      completion?()
                     }
                    return
                }
                DispatchQueue.main.async {
                    if let imgData = data, let imageToCache = UIImage(data: imgData) {
                        if self.imageUrlString == urlString {
                            self.image = imageToCache
                        }
                        imageCache.setObject(imageToCache, forKey: urlString as NSString)
                    } else {
                        self.image = placeholder
                    }
                    completion?()
                }
            }.resume()
        } else {
            self.image = placeholder
            completion?()
        }
    }
}
