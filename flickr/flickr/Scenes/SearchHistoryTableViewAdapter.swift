//
//  SearchHistoryTableViewAdapter.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//

import Foundation
import UIKit

final class SearchHistoryTableViewAdapter: NSObject {
    
    typealias DataSource = UITableViewDiffableDataSource<Section, String>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, String>
    
    enum Section {
        case all
    }
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self.datasource
    }
    
    func updateSearchHistory(_ history: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.all])
        snapshot.appendItems(history)
        datasource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    var onSearchHistorySelected: ((String) -> Void)?
    
    // MARK: Private
    private let tableView: UITableView
    private lazy var datasource: DataSource = {
        let datasource = DataSource(tableView: self.tableView, cellProvider: { (tableView, indexPath, searchText) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = searchText
            cell.contentConfiguration = content
            return cell
        })
        return datasource
    }()
}

extension SearchHistoryTableViewAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selected = datasource.itemIdentifier(for: indexPath) else { return }
        onSearchHistorySelected?(selected)
    }
}
