//
//  ImageSearchViewControllerTests.swift
//  flickrTests
//
//  Created by Krishan Sunil Premaretna on 2021-10-24.
//

import XCTest
import Quick
import Nimble
@testable import flickr

class ImageSearchViewControllerTests: QuickSpec {
    override func spec() {
        describe("ImageSearchViewController") {
            context("bind view model") {
                it("view model should not be empty") {
                    let sut = ImageSearchViewController()
                    sut.bindViewModel(MockImageSearchViewModel())
                    expect(sut.viewModel).toNot(beNil())
                }
            }
            
            context("bind") {
                it("should not call viewModel search") {
                    let sut = ImageSearchViewController()
                    let mockVM = MockImageSearchViewModel()
                    expect(mockVM.searchCalled).to(beFalse())
                    sut.bindViewModel(mockVM)
                    expect(mockVM.searchCalled).to(beFalse())
                }
            }
        }
    }
}

final class MockImageSearchViewModel: ImageSearchDataProvidable {
    func search(for searchText: String) {
        searchCalled = true
    }
    
    private(set) var searchCalled: Bool = false
    
    init() {}
    init(with useCase: FlickrSearchDataProvidable) {}
    
    var updateViewBasedOn: ((ImageSearchViewModel.State) -> Void)?
}
