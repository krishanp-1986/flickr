//
//  ImageSearchViewController.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import UIKit

class ImageSearchViewController: BaseViewController<ImageSearchDataProvidable> {
    
    override func bind() {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.search(for: "cricket")
    }
}


