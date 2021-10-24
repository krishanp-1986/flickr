//
//  ImageResultsCollectionViewAdapter.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//

import Foundation
import UIKit

struct ImageResultsCollectionViewAdapter {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ImageCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ImageCollectionViewCellViewModel>
    
    enum Section {
        case all
    }
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: self.collectionView,
                                    cellProvider: { collectionView, indexPath, imageCellViewModel -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.reuseIdentifier,
                                                          for: indexPath) as? SearchResultCollectionViewCell
            cell?.configure(imageCellViewModel)
            return cell
        })
        return dataSource
    }()
    
    init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView.dataSource =  self.dataSource
    }
    
    mutating func updateSearchResults(_ results: [ImageCollectionViewCellViewModel]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.all])
        snapShot.appendItems(results, toSection: .all)
        dataSource.apply(snapShot, animatingDifferences: false, completion: nil)
    }
    
    // MARK: Private
    private let collectionView: UICollectionView
}
