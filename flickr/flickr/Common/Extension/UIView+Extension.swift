//
//  UIView+Extension.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//

import Foundation
import UIKit

extension UIView  {
    
    func addSubViews(_ views: UIView...) {
        views.forEach(self.addSubview(_:))
    }
    
    func addShadow(shadowColor: UIColor,
                   offSet: CGSize,
                   opacity: Float,
                   shadowRadius: CGFloat,
                   cornerRadius: CGFloat) {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offSet
    }
    
    func roundedCorners(_ cornerRadius: CGFloat = 20, maskedCorners: CACornerMask) {
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = maskedCorners
    }
}
