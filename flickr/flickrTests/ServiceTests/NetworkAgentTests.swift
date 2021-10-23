//
//  NetworkAgentTests.swift
//  flickrTests
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import XCTest
import Quick
import Nimble
@testable import flickr

class NetworkAgentTests: QuickSpec {
    typealias SuccessCallBack = (Decodable) -> Void
    typealias FailureCallBack = (ServiceError) -> Void
    
    private struct MockDecodable: Codable {
        let mockInt: Int
    }
    
    override func spec() {
        describe("NetowrkAgent") {
            var sut: DataProvider!
            var request: URLRequest!
            var callBack: ((Result<MockDecodable, ServiceError>) -> Void)!
            var success: SuccessCallBack?
            var failure: FailureCallBack?
            
            beforeEach {
                URLProtocol.registerClass(TestURLProtocol.self)
                sut = NetworkAgent()
                request = URLRequest(url: URL(string: "test-url")!)
                
                success = nil
                failure = nil
                
                callBack = { result in
                    switch result {
                    case .success(let mockDecodable):
                        success?(mockDecodable)
                    case .failure(let error):
                        failure?(error)
                    }
                }
            }
            
            context("For response error") {
                it("Should return ServiceError.generalError") {
                    let errorCode = -1000
                    let domain = Constants.NSErrorConstants.nsErrorDomain
                    let error = NSError(domain: domain, code: errorCode, userInfo: nil)
                    
                    TestURLProtocol.loadingHandler = { request in
                        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        return (response, .init(), error)
                    }
                    
                    var fullFill: (() -> Void)?
                    success = { _ in
                        fail("Expected call to execute to fail, but it succeeded")
                        fullFill?()
                    }
                    
                    failure = { error in
                        expect(error.errorDescription).to(equal(error.localizedDescription))
                        expect(error).to(equal(ServiceError.generalError(error)))
                        
                        switch error {
                        case .generalError(let customError):
                            expect((customError as NSError).code).to(equal(errorCode))
                            expect((customError as NSError).domain).to(equal(domain))
                        default:
                            fail("Expected general Error with error code \(errorCode) , but got different service error")
                        }
                        
                        fullFill?()
                    }
                    
                    waitUntil { done in
                        sut.execute(request, whenDone: callBack)
                        fullFill = done
                    }
                }
            }
            
            context("For failed response") {
                it("Should return ServiceError.invalidResponse") {
                    var fullFill: (() -> Void)?
                    
                    TestURLProtocol.loadingHandler = { request in
                        return (nil, .init(), nil)
                    }
                    
                    success = { _ in
                        fail("Expected call to execute to fail, but it succedded")
                        fullFill?()
                    }
                    
                    failure = { error in
                        expect(error.errorDescription).to(equal("Invalid Response"))
                        expect(error).to(equal(ServiceError.invalidResponse))
                        fullFill?()
                    }
                    
                    waitUntil { done in
                        sut.execute(request, whenDone: callBack)
                        fullFill = done
                    }
                }
            }
            
            context("For non successful response code") {
                it("should return ServiceError.unSuccessfulResponse") {
                    let invalidResponseCode = 500
                    var fullFill: (() -> Void)?
                    
                    TestURLProtocol.loadingHandler = { request in
                        let response = HTTPURLResponse(url: request.url!, statusCode: invalidResponseCode, httpVersion: nil, headerFields: nil)!
                        return (response, .init(), nil)
                    }
                    
                    success = { _ in
                        fail("Expected call to execute to fail, but it succeeded")
                        fullFill?()
                    }
                    
                    failure = { error in
                        expect(error.errorDescription).to(equal("Server replied with errorCode : 500"))
                        expect(error).to(equal(ServiceError.unSuccessfulResponse(500)))
                        fullFill?()
                    }
                    
                    waitUntil { done in
                        sut.execute(request, whenDone: callBack)
                        fullFill = done
                    }
                }
            }

            context("For invalid data") {
                it("Should return ServiceError.inValidData") {
                    var fullFill: (() -> Void)?
                    
                    TestURLProtocol.loadingHandler = { request in
                        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        return (response, .init(), nil)
                    }
                    
                    success = { _ in
                        fail("Expected call to execute to fail, but it succeeded")
                        fullFill?()
                    }
                    
                    failure = { error in
                        expect(error.errorDescription).to(equal("Server failed to return Data"))
                        expect(error).to(equal(ServiceError.inValidData))
                        fullFill?()
                    }
                    
                    waitUntil { done in
                        sut.execute(request, whenDone: callBack)
                        fullFill = done
                    }
                }
            }
            
            context("For invalid decodable data") {
                it("Should return ServiceError.generalError") {
                    var fullFill: (() -> Void)?

                    TestURLProtocol.loadingHandler = { request in
                        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        let data =  "{}".data(using: .utf8)
                        return (response, data, nil)
                    }
                    
                    success = { _ in
                        fail("Expected call to execute to fail, but it succeeded")
                        fullFill?()
                    }
                    
                    failure = { error in
                        expect(error.errorDescription).to(equal(error.localizedDescription))
                        expect(error).to(equal(ServiceError.generalError(error)))
                        fullFill?()
                    }
                    
                    waitUntil { done in
                        sut.execute(request, whenDone: callBack)
                        fullFill = done
                    }
                }
            }
            
            context("For valid response") {
                it("Should return Decodable object successfully") {
                    var fullFill: (() -> Void)?
                    let encodable = MockDecodable(mockInt: 1)
                
                    TestURLProtocol.loadingHandler = { request in
                        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        
                        let data =  try? JSONEncoder().encode(encodable)
                        return (response, data, nil)
                    }
                    
                    success = { mockObject in
                        expect(mockObject).toNot(beNil())
                        let mockInt = (mockObject as? MockDecodable)?.mockInt ?? 0
                        expect(mockInt) == encodable.mockInt
                        fullFill?()
                    }
                    
                    failure = { error in
                        fail("Expected call to execute to success, but it succeeded")
                        fullFill?()
                    }
                    
                    waitUntil { done in
                        sut.execute(request, whenDone: callBack)
                        fullFill = done
                    }
                }
            }
        }
    }
}
