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
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if error != nil {
                self?.setImage(nil)
                return
            }
            
            guard let data = data else { return }
            guard let image = UIImage(data: data) else {
                self?.setImage(nil)
                return
            }
            imageCache.setObject(image, forKey: urlString as AnyObject)
            self?.setImage(image)
        }.resume()

    }
    
    private func setImage(_ image: UIImage?) {
        let imageToSet = image ?? .init(systemName: "photo")
        DispatchQueue.main.async {
            // TODO: If Image is nil, set placeholder image
            self.image = imageToSet
        }
    }
}
