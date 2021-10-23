//
//  FlickrSearchUseCase.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

protocol FlickrSearchDataProvidable: Service {
    func search(for text: String, page: Int, whenDone: @escaping (Result<SearchResultsDTO, ServiceError>) -> Void)
}

struct FlickrSearchUseCase: FlickrSearchDataProvidable {
    func search(for text: String, page: Int, whenDone: @escaping (Result<SearchResultsDTO, ServiceError>) -> Void) {
        guard let request = EndPoint.search(searchText: text, page: page).request else {
            let error = NSError(domain: Constants.NSErrorConstants.nsErrorDomain,
                                code: Constants.NSErrorConstants.failedRequestErrorCode,
                                userInfo: nil)
            whenDone(.failure(.generalError(error)))
            return
        }
        
        dataProvider.execute(request, whenDone: whenDone)
    }
    
    var dataProvider: DataProvider!
}
