//
//  ImageSearchViewModel.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

protocol ImageSearchDataProvidable {
    init(with useCase: FlickrSearchDataProvidable)
    var updateViewBasedOn: ((ImageSearchViewModel.State) -> Void)? {get set}
    func search(for searchText: String)
    func loadMore()
    func loadSearchHistory()
}

final class ImageSearchViewModel: ImageSearchDataProvidable {
    var updateViewBasedOn: ((State) -> Void)?

    init(with useCase: FlickrSearchDataProvidable) {
        self.useCase = useCase
    }
    
   func search(for searchText: String) {
       
       if let lastSearch = self.recentSearches.first, lastSearch.caseInsensitiveCompare(searchText) == .orderedSame {
           return
       }
       
       self.updateViewBasedOn?(.loading)
       currentPageIndex = 1
       totalPages = 0
       self.requestForImages(searchText, pageIndex: currentPageIndex)
       
       updateRecentSearchHistory(searchText)
    }
    
    func loadMore() {
        if currentPageIndex == totalPages { return }
        
        if isLoading {
            return
        }
        self.requestForImages(self.recentSearches.last ?? "", pageIndex: self.currentPageIndex + 1)
        self.currentPageIndex += 1
    }
    
    func loadSearchHistory() {
        self.updateViewBasedOn?(.searchStarted(recentSearches))
    }
    
    // MARK: Private
    private let useCase: FlickrSearchDataProvidable
    private var currentPageIndex: Int = 1
    private var totalPages: Int = 0
    private var isLoading: Bool = false
    private var recentSearches: [String] = []
    
    private func requestForImages(_ searchText: String, pageIndex: Int) {
        self.isLoading = true
        self.useCase.search(for: searchText, page: pageIndex) {[weak self] results in
            self?.isLoading = false
            switch results {
            case .success(let searchResult):
                 self?.resultsLoaded(searchResult)
                break
            case .failure(let error):
                self?.updateViewBasedOn?(.error(error))
            }
        }
    }
    
    private func updateRecentSearchHistory(_ searchText: String) {
        if let existingIndex = self.recentSearches.firstIndex(of: searchText) {
            self.recentSearches.remove(at: existingIndex)
        }
        self.recentSearches.insert(searchText, at: 0)
    }
}

extension ImageSearchViewModel {
    // Viewmodel acts like state machine
    enum State {
        case loading
        case searchStarted([String])
        case loaded([ImageCollectionViewCellViewModel])
        case error(Error)
    }
}

private extension ImageSearchViewModel {
    func resultsLoaded(_ searchResult: SearchResultsDTO) {
        self.totalPages = searchResult.photos.pages
        
        let resultsCellViewModels = transform(searchResult)
        self.updateViewBasedOn?(.loaded(resultsCellViewModels))
    }
    
    func transform(_ searchDTO: SearchResultsDTO) -> [ImageCollectionViewCellViewModel] {
        searchDTO.photos.photo.map {
            ImageCollectionViewCellViewModel(imageUrl: getImageUrl(for: $0), title: $0.title)
        }
    }
    
    func getImageUrl(for photo: Photo) -> String {
        "http://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
    }
}
