//
//  ImageSearchViewController.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import UIKit
import SnapKit

class ImageSearchViewController: BaseViewController<ImageSearchDataProvidable> {
    
    override func bind() {
        self.collectionViewAdapter.loadMoreListener = { [weak self] in
            self?.viewModel.loadMore()
        }
        
        self.viewModel.updateViewBasedOn = { [weak self] state in
            switch state {
            case .loaded(let resultsViewModel):
                self?.collectionViewAdapter.updateSearchResults(resultsViewModel)
                self?.shouldShowLoading(false)
                break
            case .error(let error):
                self?.shouldShowLoading(false)
                self?.displayBasicAlert(for: error)
            case .loading:
                self?.shouldShowLoading(true)
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        buildUI()
        configureSearchController()
    }
    
    // MARK: Private
    private func buildUI() {
        self.view.addSubview(imagesCollectionView)
        let safeAreaLayoutGuide = self.view.safeAreaLayoutGuide
        self.imagesCollectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Images"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchTimer: Timer?
    private lazy var collectionViewAdapter =  ImageResultsCollectionViewAdapter(with: self.imagesCollectionView)
    private lazy var imagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.registerCell(SearchResultCollectionViewCell.self)
        return collectionView
    }()
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let spacing = CGFloat(8)
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ImageSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchTimer?.invalidate()
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.collectionViewAdapter.reset()
            self?.viewModel.search(for: searchText)
        })
    }
}

