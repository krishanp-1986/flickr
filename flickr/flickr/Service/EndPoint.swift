//
//  EndPoint.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

enum EndPoint {
    private static let baseUrl = "https://www.flickr.com"
    private static let apiKey = "efcd71edd055793cb13049e260163a6b"
    private static let perPage = 20
    
    case search(searchText: String, page: Int)
    
    private var httpMethod: String {
        switch self {
        case .search:
            return "GET"
        }
    }
    
    private var path: String {
        switch self {
        case .search:
            return "/services/rest/"
        }
    }
    
    private var method: String {
        switch self {
            case .search:
            return "flickr.photos.search"
        }
    }
    
    private var queryItems: [String: String] {
        switch self {
        case .search(let searchText, let page):
            return [Constants.StringConstants.URLConstants.text: searchText,
                    Constants.StringConstants.URLConstants.page: String(page),
                    Constants.StringConstants.URLConstants.per_page: String(Self.perPage),
                    Constants.StringConstants.URLConstants.format: Constants.StringConstants.URLConstants.json,
                    Constants.StringConstants.URLConstants.apiKey: Self.apiKey,
                    Constants.StringConstants.URLConstants.method: self.method]
            
        }
    }

    
    var request: URLRequest? {
        var urlComponents = URLComponents(string: Self.baseUrl)
        urlComponents?.path = path
        urlComponents?.setQueryItems(with: queryItems)
        
        guard let url = urlComponents?.url else { return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        return request
    }
}
