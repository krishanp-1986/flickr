//
//  ImageSearchViewModel.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

protocol ImageSearchDataProvidable {
    init(with useCase: FlickrSearchDataProvidable)
    func search(for searchText: String)
}

final class ImageSearchViewModel: ImageSearchDataProvidable {
    private let useCase: FlickrSearchDataProvidable
    private var currentPageIndex: Int = 0
    
    init(with useCase: FlickrSearchDataProvidable) {
        self.useCase = useCase
    }
    
   func search(for searchText: String) {
        currentPageIndex = 0
        self.useCase.search(for: searchText, page: currentPageIndex) { _ in
            
        }
    }
}
