//
//  ImageResultsCollectionViewAdapter.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//

import Foundation
import UIKit

final class ImageResultsCollectionViewAdapter: NSObject {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ImageCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ImageCollectionViewCellViewModel>
    
    enum Section {
        case all
    }
        
    init(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.dataSource =  self.dataSource
        self.collectionView.delegate = self
    }
    
    func updateSearchResults(_ results: [ImageCollectionViewCellViewModel]) {
        
        defer {
            totalSearchResults += results.count
            itemsToAddAfter = results.last
        }
        
        if totalSearchResults != 0 {
            loadMoreSearchResults(results)
            return
        }
        
        populateCollectionView(results)
    }
    
    func reset() {
        var snapShotToReset = dataSource.snapshot()
        snapShotToReset.deleteSections([.all])
        dataSource.apply(snapShotToReset, animatingDifferences: false, completion: nil)
        totalSearchResults = 0
    }
    
    var loadMoreListener: (() -> Void)?
    
    // MARK: Private
    private let collectionView: UICollectionView
    private var totalSearchResults: Int = 0
    private var itemsToAddAfter: ImageCollectionViewCellViewModel!
    
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
    
    private func populateCollectionView(_ results: [ImageCollectionViewCellViewModel]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.all])
        snapShot.appendItems(results, toSection: .all)
        dataSource.apply(snapShot, animatingDifferences: false, completion: nil)
    }
    
    private func loadMoreSearchResults(_ results: [ImageCollectionViewCellViewModel]) {
        var newSnapshot = dataSource.snapshot()
        newSnapshot.insertItems(results, afterItem: itemsToAddAfter)
        dataSource.apply(newSnapshot, animatingDifferences: false, completion: nil)
    }
}

extension ImageResultsCollectionViewAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let willDisplayRowNumber = indexPath.row
        if willDisplayRowNumber == totalSearchResults - 1 {
            loadMoreListener?()
        }
    }
}
