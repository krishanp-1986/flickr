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
        self.collectionViewAdapter.loadMoreListener = { [unowned self] in
            self.viewModel.loadMore()
        }
        
        self.searchHistoryTableViewAdapter.onSearchHistorySelected = { [unowned self] searchText in
            self.searchHistoryTableView.removeFromSuperview()
            self.searchController.searchBar.resignFirstResponder()
            self.request(searchText)
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
                self?.collectionViewAdapter.reset()
                self?.shouldShowLoading(true)
            case .searchStarted(let histories):
                self?.searchHistoryTableViewAdapter.updateSearchHistory(histories)
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
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var collectionViewAdapter =  ImageResultsCollectionViewAdapter(with: self.imagesCollectionView)
    private lazy var imagesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.registerCell(SearchResultCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var searchHistoryTableViewAdapter = SearchHistoryTableViewAdapter(with: self.searchHistoryTableView)
    private lazy var searchHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.registerCell(UITableViewCell.self)
        return tableView
    }()
    
    private func createLayout() -> UICollectionViewLayout {
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
    
    private func request(_ searchText: String) {
        self.searchController.searchBar.text = ""
        self.viewModel.search(for: searchText)
    }
}

extension ImageSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
}

extension ImageSearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        addSearchHistoryTableView()
        self.viewModel.loadSearchHistory()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchHistoryTableView.removeFromSuperview()
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        request(searchText)
    }
    
    private func addSearchHistoryTableView() {
        self.view.addSubview(searchHistoryTableView)
        let safeAreaLayoutGuide = self.view.safeAreaLayoutGuide
        self.searchHistoryTableView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}

