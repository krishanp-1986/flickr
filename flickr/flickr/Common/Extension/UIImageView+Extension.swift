//
//  UIImageView+Extension.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//
import Foundation
import UIKit

// In Memory cache to store the images
private var imageCache = NSCache<AnyObject, AnyObject>()

public extension UIImageView {

     func loadImage(urlString: String) {
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            guard let data = data else { return }
            guard let image = UIImage(data: data) else {
                return
            }
            imageCache.setObject(image, forKey: urlString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()

    }
}
