//
//  MockFlickrSearchUseCase.swift
//  flickrTests
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//

import Foundation
@testable import flickr

struct MockFlickrSearchUseCase: FlickrSearchDataProvidable {
    var fileName: String = ""
    func search(for text: String, page: Int, whenDone: @escaping (Result<SearchResultsDTO, ServiceError>) -> Void) {
        if let mockAgent = dataProvider as? MockNetworkAgent {
            mockAgent.mockFileName = fileName
        }
        dataProvider.execute(.mock, whenDone: whenDone)
    }
    
    var dataProvider: DataProvider! = MockNetworkAgent()
}

extension URLRequest {
    static var mock = URLRequest(url: URL(string: "mock-request")!)
}
