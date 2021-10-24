//
//  Reusable.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//

import Foundation
import UIKit

protocol Reusable {
    typealias Cell = UICollectionViewCell & Reusable
    static var reuseIdentifier: String { get }
}

extension Reusable where Self: UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: type(of: self))
    }
}

extension UICollectionView {
    func registerCell<C: Reusable.Cell>(_ type: C.Type) {
        register(type, forCellWithReuseIdentifier: C.reuseIdentifier)
    }
}
