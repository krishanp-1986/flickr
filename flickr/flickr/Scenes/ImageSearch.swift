//
//  ImageSearch.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation
import UIKit

struct ImageSearch {
    static func build() -> UIViewController {
        let useCase = ServiceFactory.useCaseFor(FlickrSearchUseCase.self)
        let imageSearchVC = ImageSearchViewController()
        let imageSearchViewModel = ImageSearchViewModel(with: useCase)
        imageSearchVC.bindViewModel(imageSearchViewModel)
        return imageSearchVC
    }
}
