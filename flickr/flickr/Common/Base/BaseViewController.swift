//
//  BaseViewController.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation
import UIKit

class BaseViewController<VM>: UIViewController, BindableType {
    var viewModel: VM!
    
    override func loadView() {
        super.loadView()
    }
    
    func bind() {
        // Subclass must override this method
    }
    
    func displayBasicAlert(for error: Error) {
        let alertViewController = UIAlertController(title: "Error",
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
}

