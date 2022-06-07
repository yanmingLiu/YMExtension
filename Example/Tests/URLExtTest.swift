//
//  URL.swift
//  YMExtension_Tests
//
//  Created by lym on 2022/6/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//
@testable import YMExtension

import XCTest
import Foundation

class URLExtTest: XCTestCase {
    var url = URL(string: "https://www.google.com")!
    let params = ["q": "swifter swift"]
    let queryUrl = URL(string: "https://www.google.com?q=swifter%20swift")!

    func testQueryParameters() {
        let url = URL(string: "https://www.google.com?q=swifter%20swift&steve=jobs&empty")!
        guard let parameters = url.ext.queryParameters else {
            XCTAssert(false)
            return
        }

        XCTAssertEqual(parameters.count, 2)
        XCTAssertEqual(parameters["q"], "swifter swift")
        XCTAssertEqual(parameters["steve"], "jobs")
        XCTAssertNil(parameters["empty"])
    }

    func testValueForQueryKey() {
        let url = URL(string: "https://google.com?code=12345&empty")!

        let codeResult = url.ext.queryValue(for: "code")
        let emtpyResult = url.ext.queryValue(for: "empty")
        let otherResult = url.ext.queryValue(for: "other")

        XCTAssertEqual(codeResult, "12345")
        XCTAssertNil(emtpyResult)
        XCTAssertNil(otherResult)
    }

    func testDeletingAllPathComponents() {
        let url = URL(string: "https://domain.com/path/other/")!
        let result = url.ext.deletingAllPathComponents()
        XCTAssertEqual(result.absoluteString, "https://domain.com/")
    }

}
