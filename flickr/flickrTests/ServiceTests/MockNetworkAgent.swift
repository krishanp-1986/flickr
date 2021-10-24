//
//  MockAgent.swift
//  flickrTests
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation
@testable import flickr

class MockNetworkAgent: DataProvider {
    private let bundle = Bundle(for: MockNetworkAgent.self)
    var mockFileName: String = ""
    
    func cancel() {}
    
    func execute<T>(_ request: URLRequest, whenDone: @escaping (Result<T, ServiceError>) -> Void) where T: Decodable {
        DispatchQueue.main.async {
            guard let decodable = JsonUtils.convertJsonIntoDecodable(T.self,
                                                                     fileName: self.mockFileName,
                                                               bundle: self.bundle, inDirectory: "TestResponse") else {
                
                whenDone(.failure(.inValidData))
                return
            }

            whenDone(.success(decodable))
        }
    }
}
