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
        self.view.backgroundColor = .white
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
    
    func shouldShowLoading(_ isLoading: Bool) {
        if isLoading {
            if (self.loadingIndicatorView.superview != nil) { return }
            self.view.addSubview(loadingIndicatorView)
            loadingIndicatorView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            self.loadingIndicatorView.removeFromSuperview()
        }
    }
    
    private lazy var loadingIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.8)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.backgroundColor = .white
        activityIndicator.startAnimating()

        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return view
    }()
}

