//
//  JsonUtilsTests.swift
//  flickrTests
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import XCTest
import Quick
import Nimble
@testable import flickr

class JsonUtilsTests: QuickSpec {
    private let bundle = Bundle(for: JsonUtilsTests.self)
    override func spec() {
        describe("json utility") {
            context("for valid json") {
                it("should convert into decodable") {
                    let decoded = JsonUtils.convertJsonIntoDecodable([String: String].self,
                                                                     fileName: "valid",
                                                                     bundle: self.bundle, inDirectory: "TestResponse")
                    expect(decoded).toNot(beNil())
                    expect(decoded?.keys.count) == 2
                }
            }
            
            context("for valid search results") {
                it("should return search results dto") {
                    let decoded = JsonUtils.convertJsonIntoDecodable(SearchResultsDTO.self,
                                                                     fileName: "search",
                                                                     bundle: self.bundle,
                                                                     inDirectory: "TestResponse")
                    expect(decoded).toNot(beNil())
                }
            }

            
            context("for empty json") {
                it("should convert into decodable ") {
                    let decoded = JsonUtils.convertJsonIntoDecodable([String: String].self,
                                                                     fileName: "empty",
                                                                     bundle: self.bundle, inDirectory: "TestResponse")
                    expect(decoded).toNot(beNil())
                    expect(decoded?.keys).to(beEmpty())
                }
            }
            
            context("for invalid json") {
                it("should return nil") {
                    let decoded = JsonUtils.convertJsonIntoDecodable([String: String].self,
                                                                     fileName: "invalid",
                                                                     bundle: self.bundle, inDirectory: "TestResponse")
                    expect(decoded).to(beNil())
                }
            }

        }
    }
}
