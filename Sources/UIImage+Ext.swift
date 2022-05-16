//
//  UIImage+Ext.swift
//  LegendTeam
//
//  Created by dong on 2021/12/15.
//

import UIKit

extension UIImage: ExtCompatible {}

public extension ExtWrapper where Base: UIImage {
    /// 根据渐变颜色生成渐变图片
    static func gradientColorImage(bounds: CGRect,
                                   colors: [CGColor],
                                   startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                                   endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5),
                                   locations: [NSNumber]? = [0, 1]) -> UIImage?
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = [0, 1]
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 图片压缩
    func compress(toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = base.jpegData(compressionQuality: compression),
              data.count > maxLength else { return base }

        print("压缩前：\(data.count / 1024) KB")

        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            data = base.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        print("压缩（by size）后1：\(data.count / 1024) KB")

        var resultImage = UIImage(data: data)!
        if data.count < maxLength { return resultImage }

        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio = CGFloat(maxLength) / CGFloat(data.count)
            let size = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                              height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!
        }
        print("压缩（by size）后2：\(data.count / 1024) KB")
        return resultImage
    }
}
