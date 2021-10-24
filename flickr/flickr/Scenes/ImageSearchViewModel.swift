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
}

final class ImageSearchViewModel: ImageSearchDataProvidable {
    var updateViewBasedOn: ((State) -> Void)?

    init(with useCase: FlickrSearchDataProvidable) {
        self.useCase = useCase
    }
    
   func search(for searchText: String) {
       self.updateViewBasedOn?(.loading)
        currentPageIndex = 0
        self.useCase.search(for: searchText, page: currentPageIndex) {[weak self] results in
            switch results {
            case .success(let searchResult):
                 self?.resultsLoaded(searchResult)
                break
            case .failure(let error):
                self?.updateViewBasedOn?(.error(error))
            }
        }
    }
    
    // MARK: Private
    private let useCase: FlickrSearchDataProvidable
    private var currentPageIndex: Int = 0
}

extension ImageSearchViewModel {
    // Viewmodel acts like state machine
    enum State {
        case loading
        case loaded([ImageCollectionViewCellViewModel])
        case error(Error)
    }
}

private extension ImageSearchViewModel {
    func resultsLoaded(_ searchResult: SearchResultsDTO) {
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
