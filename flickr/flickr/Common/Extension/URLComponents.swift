//
//  URLComponents.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map({  URLQueryItem(name: $0.key, value: $0.value) })
    }
}

