//
//  CollectionViewCellViewModel.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//

import Foundation

struct ImageCollectionViewCellViewModel {
    let imageUrl: String
    let title: String
    let id = UUID()
}

extension ImageCollectionViewCellViewModel : Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ImageCollectionViewCellViewModel, rhs: ImageCollectionViewCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
