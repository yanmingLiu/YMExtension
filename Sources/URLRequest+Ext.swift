//
//  URLRequest+Ext.swift
//  YMExtension
//
//  Created by lym on 2022/6/8.
//

import Foundation

extension URLRequest: ExtCompatible {}

public extension ExtWrapper where Base == URLRequest {
    /// SwifterSwift: cURL command representation of this URL request.
    var curlString: String {
        guard let url = base.url else { return "" }

        var baseCommand = "curl \(url.absoluteString)"
        if base.httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]
        if let method = base.httpMethod, method != "GET", method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = base.allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = base.httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}
