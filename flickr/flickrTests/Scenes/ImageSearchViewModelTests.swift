//
//  ImageSearchViewModelTests.swift
//  flickrTests
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//

import XCTest
import Quick
import Nimble
@testable import flickr

class ImageSearchViewModelTests: QuickSpec {
    
    override func spec() {
        describe("ImageSearchViewModel") {
            
            var mockFlickerSearchUseCase: MockFlickrSearchUseCase!
            beforeEach {
                mockFlickerSearchUseCase = MockFlickrSearchUseCase()
            }
            
            context("Successfully search images") {
                it("Should call updateViewBasedOn with loaded") {
                    mockFlickerSearchUseCase.fileName = "search"
                    let sut = ImageSearchViewModel(with: mockFlickerSearchUseCase)
                    var fullFill: (() -> Void)?
                    sut.updateViewBasedOn = { state in
                        switch state {
                        case .loading: break
                        case .loaded(let models):
                            expect(models).toNot(beNil())
                            expect(models).toNot(beEmpty())
                            fullFill?()
                        default:
                            fail("Expecting Loading / loaded state, but got error")
                        }
                    }
                    waitUntil { done in
                        sut.search(for: "")
                        fullFill = done
                    }
                }
            }
            
            context("failed to search images") {
                it("should call updateViewBasedOn with error") {
                    mockFlickerSearchUseCase.fileName = "invalid"
                    let sut = ImageSearchViewModel(with: mockFlickerSearchUseCase)
                    var fullFill: (() -> Void)?
                    sut.updateViewBasedOn = { state in
                        switch state {
                        case .loading: break
                        case .error(let error):
                            expect(error).toNot(beNil())
                            fullFill?()
                        default:
                            fail("Expecting Loading / error state, but got loaded")
                        }
                    }
                    waitUntil { done in
                        sut.search(for: "")
                        fullFill = done
                    }
                }
            }
        }
    }
}
