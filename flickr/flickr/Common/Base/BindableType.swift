//
//  BindableType.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation
import UIKit

protocol BindableType: AnyObject {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set}
    func bind()
}

extension BindableType where Self: UIViewController {
    func bindViewModel(_ viewModel: ViewModelType) {
        self.viewModel = viewModel
        bind()
    }
}
