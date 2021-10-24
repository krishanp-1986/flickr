//
//  CardView.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//

import UIKit

class CardView: UIView {
    private let cornerRadius: CGFloat = CGFloat(20)
    private let shadowOfSetWidth: CGFloat = 0
    private let shadowOfSetHeight: CGFloat = 10
    
    private let shadowColour: UIColor = UIColor.black.withAlphaComponent(0.5)
    private let shadowOpacity: CGFloat = 0.2
    private let isSelected: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addShadow() {
        addShadow(shadowColor: shadowColour,
                  offSet: CGSize(width: shadowOfSetWidth, height: shadowOfSetHeight),
                  opacity: 0.2,
                  shadowRadius: cornerRadius/2,
                  cornerRadius: cornerRadius)
    }
}
