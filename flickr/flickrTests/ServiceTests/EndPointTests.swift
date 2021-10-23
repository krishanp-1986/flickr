//
//  EndPointTests.swift
//  flickrTests
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import XCTest
import Quick
import Nimble
@testable import flickr

class EndPointTests: QuickSpec {
    
    override func spec() {
        describe("Enpoint") {
            context("when requesting for flickr search request") {
                let page = 0
                let request = EndPoint.search(searchText: "", page: page).request
                it("should return non nil request") {
                    expect(request).toNot(beNil())
                }
                
                it("should return correct http method") {
                    expect(request?.httpMethod).to(equal("GET"))
                }
                
                it("should return correct request path") {
                    expect(request?.url?.path).to(equal("/services/rest"))
                }
                
                it("should contain correct query params") {
                    let query = request?.url?.query
                    expect(query).to(contain("\(Constants.StringConstants.URLConstants.method)=flickr.photos.search"))
                    expect(query).to(contain("\(Constants.StringConstants.URLConstants.page)=\(page)"))
                    expect(query).to(contain("\(Constants.StringConstants.URLConstants.per_page)=20"))
                    expect(query).to(contain("\(Constants.StringConstants.URLConstants.format)=json"))
                    expect(query).to(contain("\(Constants.StringConstants.URLConstants.apiKey)"))
                }
            }
        }
    }

}
