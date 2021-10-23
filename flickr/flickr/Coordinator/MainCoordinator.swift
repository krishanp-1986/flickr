//
//  MainCoordinator.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation
import UIKit

struct MainCoordinator: Coordinator {
    private let window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let imageSearchViewController = ImageSearch.build()
        window?.rootViewController = imageSearchViewController
        window?.makeKeyAndVisible()
    }
}
