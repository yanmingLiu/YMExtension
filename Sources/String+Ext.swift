//
//  String+Ext.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//

import Foundation
import UIKit

extension String: ExtCompatible {}

// MARK: - get

public extension ExtWrapper where Base == String {
    /// 随机字符串
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }

    /// 去掉字符串首尾的空格换行，中间的空格和换行忽略
    var trimmed: String {
        return base.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 字符串的全部范围
    var rangeOfAll: NSRange {
        return NSRange(location: 0, length: base.count)
    }

    /// 设备的UUID
    var UUID: String? {
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let cfString = CFUUIDCreateString(kCFAllocatorDefault, uuid)
        return cfString as String?
    }

    /// 判断是否包含某个子串
    func contains(_ find: String) -> Bool {
        return base.range(of: find) != nil
    }
}

// MARK: - transform

public extension ExtWrapper where Base == String {
    /// NSRange转换为当前字符串的Range
    ///
    /// - Parameter range: NSRange对象
    /// - Returns: 当前字符串的范围
    func range(for range: NSRange) -> Range<String.Index>? {
        return Range(range, in: base)
    }

    /// 字符串转 AnyClass
    @discardableResult
    func toClass() -> AnyClass? {
        if base.isEmpty {
            return nil
        }
        // 1.动态获取命名空间
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            return nil
        }
        // 2.将字符串转换为类
        // 2.1.默认情况下命名空间就是项目的名称，但是命名空间的名称是可以更改的
        let string = namespace.replacingOccurrences(of: " ", with: "_") + "." + base
        guard let Class = NSClassFromString(string) else {
            return nil
        }
        return Class
    }

    /// JSON 字符串 转换为 字典
    func toDictionary() -> [String: Any]? {
        guard let jsonData = base.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        else {
            return nil
        }
        return dict as? [String: Any]
    }

    /// JSON 字符串 转换为  Array
    func jsonStringToArray() -> [Any]? {
        guard let jsonData: Data = base.data(using: .utf8),
              let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        else {
            return nil
        }
        return array as? [Any]
    }

    /// 转成拼音
    /// - Parameter isLatin: true：带声调，false：不带声调，默认 false
    /// - Returns: 拼音
    func toPinyin(_ isTone: Bool = false) -> String {
        let mutableString = NSMutableString(string: base)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        if !isTone {
            // 不带声调
            CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        }
        return mutableString as String
    }

    /// 字符串的首字母, "爱国" --> AG
    /// - Parameter isUpper:  true：大写首字母，false: 小写首字母，默认 true
    func firstPinyin(_ isUpper: Bool = true) -> String {
        let pinyin = toPinyin(false).components(separatedBy: " ")
        let initials = pinyin.compactMap { String(format: "%c", $0.cString(using: .utf8)![0]) }
        return isUpper ? initials.joined().uppercased() : initials.joined()
    }
}

// MARK: - regular

public extension ExtWrapper where Base == String {
    /// 正则匹配
    ///
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配选项
    /// - Returns: 是否匹配
    func matches(regex: String, options: NSRegularExpression.Options) -> Bool {
        guard let pattern = try? NSRegularExpression(pattern: regex, options: options) else {
            return false
        }
        return pattern.numberOfMatches(in: base, options: [], range: rangeOfAll) > 0
    }

    /// 枚举所有正则表达式匹配项
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配选项
    ///   - closure: 功能闭包
    func enumerate(regex: String, options: NSRegularExpression.Options, closure: (_ match: String, _ matchRange: Range<String.Index>, _ stop: UnsafeMutablePointer<ObjCBool>) -> Void) {
        guard regex.isEmpty else { return }
        guard let pattern = try? NSRegularExpression(pattern: regex, options: options) else {
            return
        }
        pattern.enumerateMatches(in: base, options: [], range: rangeOfAll) { result, _, stop in
            if let result = result, let range = range(for: result.range) {
                closure(String(base[range]), range, stop)
            }
        }
    }

    /// 正则替换
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配选项
    ///   - with: 待替换字符串
    /// - Returns: 新的字符串
    func replace(regex: String, options: NSRegularExpression.Options, with: String) -> String? {
        guard regex.isEmpty else { return nil }
        guard let pattern = try? NSRegularExpression(pattern: regex, options: options) else {
            return nil
        }
        return pattern.stringByReplacingMatches(in: base, options: [], range: rangeOfAll, withTemplate: with)
    }
}
