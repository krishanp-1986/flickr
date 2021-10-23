//
//  TestURLProtocol.swift
//  flickrTests
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

final class TestURLProtocol: URLProtocol {
        
    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse?, Data?, Error?))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        
        guard let handler = TestURLProtocol.loadingHandler else {
            return
        }
        
        let (response, data, error) = handler(request)
        
        if let responseError = error {
            client?.urlProtocol(self, didFailWithError: responseError)
            return
        }
        
        if let response = response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        client?.urlProtocol(self, didLoad: data ?? .init())
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        debugPrint("Stop loading")
    }
}
