//
//  ServiceFactoryTests.swift
//  flickrTests
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import XCTest
import Quick
import Nimble
@testable import flickr

class ServiceFactoryTests: QuickSpec {
    struct MockUseCase: Service {
        var dataProvider: DataProvider! = MockNetworkAgent()
        let isCreated: Bool = true
    }
    
    override func spec() {
        describe("service factory") {
            context("for valid service type") {
                it("should return valid usecase") {
                    let recipesUseCase = ServiceFactory.useCaseFor(FlickrSearchUseCase.self)
                    expect(recipesUseCase).toNot(beNil())
                    
                    let mockUseCase = ServiceFactory.useCaseFor(MockUseCase.self)
                    expect(mockUseCase).toNot(beNil())
                    expect(mockUseCase.isCreated).to(beTrue())
                }
            }
        }
    }
}
