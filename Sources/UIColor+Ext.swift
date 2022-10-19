//
//  UIColor+.swift
//  Demo1
//
//  Created by lym on 2019/5/22.
//  Copyright © 2019 lym. All rights reserved.
//

import UIKit

extension UIColor: ExtCompatible {}

public extension ExtWrapper where Base: UIColor {
    /// 随机颜色
    static func random(alpha: CGFloat = 0.5) -> UIColor {
         let r = CGFloat.random(in: 0...1)
         let g = CGFloat.random(in: 0...1)
         let b = CGFloat.random(in: 0...1)
         return UIColor(red: r, green: g, blue: b, alpha: alpha)
     }

    /// 根据16进制颜色值返回颜色
    /// - Parameters:
    ///   - hexString: 颜色值字符串: 前缀 ‘#’ 和 ‘0x’ 不是必须的
    ///   - alpha: 透明度，默认为1
    /// - Returns: UIColor
    static func hex(_ hex: String, alpha: CGFloat = 1) -> UIColor {
        var str = ""
        if hex.lowercased().hasPrefix("0x") {
            str = hex.replacingOccurrences(of: "0x", with: "")
        } else if hex.lowercased().hasPrefix("#") {
            str = hex.replacingOccurrences(of: "#", with: "")
        } else {
            str = hex
        }

        let length = str.count
        // 如果不是 RGB RGBA RRGGBB RRGGBBAA 结构
        if length != 3 && length != 4 && length != 6 && length != 8 {
            return .clear
        }

        // 将 RGB RGBA 转换为 RRGGBB RRGGBBAA 结构
        if length < 5 {
            var tStr = ""
            str.forEach { tStr.append(String(repeating: $0, count: 2)) }
            str = tStr
        }

        guard let hexValue = Int(str, radix: 16) else {
            return .clear
        }

        var red = 0
        var green = 0
        var blue = 0

        if length == 3 || length == 6 {
            red = (hexValue >> 16) & 0xFF
            green = (hexValue >> 8) & 0xFF
            blue = hexValue & 0xFF
        } else {
            red = (hexValue >> 20) & 0xFF
            green = (hexValue >> 16) & 0xFF
            blue = (hexValue >> 8) & 0xFF
        }
        return UIColor(red: CGFloat(red) / 255.0,
                       green: CGFloat(green) / 255.0,
                       blue: CGFloat(blue) / 255.0,
                       alpha: CGFloat(alpha))
    }

    /// 根据16进制颜色值返回颜色
    /// - Parameters:
    ///   - hex: 16进制数值
    ///   - alpha: 透明度，默认为1
    /// - Returns: UIColor
    static func hexInt32(_ hex: Int32, alpha: CGFloat = 1) -> UIColor {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255
        let g = CGFloat((hex & 0xFF00) >> 8) / 255
        let b = CGFloat(hex & 0xFF) / 255
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
