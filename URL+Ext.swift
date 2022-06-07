//
//  URL+Ext.swift
//  YMExtension
//
//  Created by lym on 2022/6/7.
//

import Foundation

extension URL: ExtCompatible {}

public extension ExtWrapper where Base == URL {
    /// SwifterSwift: Dictionary of the URL's query parameters.
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: base, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }

        var items: [String: String] = [:]

        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }

        return items
    }
}

public extension ExtWrapper where Base == URL {
    /// SwifterSwift: URL with appending query parameters.
    ///
    ///        let url = URL(string: "https://google.com")!
    ///        let param = ["q": "Swifter Swift"]
    ///        url.appendingQueryParameters(params) -> "https://google.com?q=Swifter%20Swift"
    ///
    /// - Parameter parameters: parameters dictionary.
    /// - Returns: URL with appending given query parameters.
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: base, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters
            .map { URLQueryItem(name: $0, value: $1) }
        return urlComponents.url!
    }

    /// SwifterSwift: Get value of a query key.
    ///
    ///    var url = URL(string: "https://google.com?code=12345")!
    ///    queryValue(for: "code") -> "12345"
    ///
    /// - Parameter key: The key of a query value.
    func queryValue(for key: String) -> String? {
        return URLComponents(string: base.absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }

    /// SwifterSwift: Returns a new URL by removing all the path components.
    ///
    ///     let url = URL(string: "https://domain.com/path/other")!
    ///     print(url.deletingAllPathComponents()) // prints "https://domain.com/"
    ///
    /// - Returns: URL with all path components removed.
    func deletingAllPathComponents() -> URL {
        var url: URL = base
        for _ in 0..<base.pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
        return url
    }

    /// SwifterSwift: Remove all the path components from the URL.
    ///
    ///        var url = URL(string: "https://domain.com/path/other")!
    ///        url.deleteAllPathComponents()
    ///        print(url) // prints "https://domain.com/"
    mutating func deleteAllPathComponents() {
        var url: URL = base
        for _ in 0..<base.pathComponents.count - 1 {
            url.deleteLastPathComponent()
        }
    }

    /// SwifterSwift: Generates new URL that does not have scheme.
    ///
    ///        let url = URL(string: "https://domain.com")!
    ///        print(url.droppedScheme()) // prints "domain.com"
    func droppedScheme() -> URL? {
        if let scheme = base.scheme {
            let droppedScheme = String(base.absoluteString.dropFirst(scheme.count + 3))
            return URL(string: droppedScheme)
        }

        guard base.host != nil else { return base }

        let droppedScheme = String(base.absoluteString.dropFirst(2))
        return URL(string: droppedScheme)
    }
}
