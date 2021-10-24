//
//  FlickrSearchUseCaseTests.swift
//  flickrTests
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import XCTest
import Quick
import Nimble
@testable import flickr

class FlickrSearchUseCaseTests: QuickSpec {
    typealias SuccessCallBack = (SearchResultsDTO) -> Void
    typealias FailureCallBack = (ServiceError) -> Void
    
    override func spec() {
        describe("flickr search UseCase") {
            var mockAgent: MockNetworkAgent!
            var sut: FlickrSearchUseCase!
            
            var callBack: ((Result<SearchResultsDTO, ServiceError>) -> Void)!
            var success: SuccessCallBack?
            var failure: FailureCallBack?
            beforeEach {
                mockAgent = MockNetworkAgent()
                sut = FlickrSearchUseCase(with: mockAgent)
                success = nil
                failure = nil
                
                callBack = { result in
                    switch result {
                    case .success(let searchResultDTO):
                        success?(searchResultDTO)
                    case .failure(let error):
                        failure?(error)
                    }
                }
            }
            context("for successful request") {
                it("should return valid search results") {
                    mockAgent.mockFileName = "search"
                    var fullFill: (() -> Void)?
                    
                    success = { searchResultDto in
                        expect(searchResultDto).toNot(beNil())
                        expect(searchResultDto.photos.photo).toNot(beEmpty())
                        fullFill?()
                    }
                    
                    failure = { _ in
                        fail("Expected call to search to succeed with searchResultsDTO, but it failed with error")
                        fullFill?()
                    }
                    
                    waitUntil { done in
                        sut.search(for: "mock-search", page: 0, whenDone: callBack)
                        fullFill = done
                    }
                }
            }
            
            context("for failed request") {
                it("should return ServiceError") {
                    mockAgent.mockFileName = "invalid"
                    var fullFill: (() -> Void)?
                    
                    success = { recipes in
                        fail("Expected call to search to fail with error, but it succeeded")
                        fullFill?()
                    }
                    
                    failure = { error in
                        expect(error).notTo(beNil())
                        fullFill?()
                    }
                    
                    waitUntil { done in
                        sut.search(for: "mock-search", page: 0, whenDone: callBack)
                        fullFill = done
                    }
                }
            }
        }
    }
}
