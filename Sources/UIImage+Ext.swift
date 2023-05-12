//
//  UIImage+Ext.swift
//  LegendTeam
//
//  Created by dong on 2021/12/15.
//

import UIKit
import CoreImage

extension UIImage: ExtCompatible {}

public extension ExtWrapper where Base: UIImage {
    /// 根据渐变颜色生成渐变图片
    static func gradientColorImage(
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0, y: 0),
        endPoint: CGPoint = CGPoint(x: 1.0, y: 0),
        bounds: CGRect = CGRect(x: 0, y: 0, width: 2, height: 2),
        locations: [NSNumber]? = [0, 1]
    ) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// 根据颜色生成图片
    static func color(color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)

        defer {
            UIGraphicsEndImageContext()
        }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        return UIImage(cgImage: aCgImage)
    }
}

public extension ExtWrapper where Base: UIImage {
    /// 图片压缩
    func compressed(toByte maxLength: Int) -> UIImage {
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

    /// SwifterSwift: Compressed UIImage from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional UIImage (if applicable).
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = base.jpegData(compressionQuality: quality) else { return nil }
        return UIImage(data: data)
    }

    /// SwifterSwift: Compressed UIImage data from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional Data (if applicable).
    func compressedData(quality: CGFloat = 0.5) -> Data? {
        return base.jpegData(compressionQuality: quality)
    }

    /// SwifterSwift: UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width <= base.size.width, rect.size.height <= base.size.height else { return base }
        let scaledRect = rect.applying(CGAffineTransform(scaleX: base.scale, y: base.scale))
        guard let image = base.cgImage?.cropping(to: scaledRect) else { return base }
        return UIImage(cgImage: image, scale: base.scale, orientation: base.imageOrientation)
    }

    /// SwifterSwift: UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / base.size.height
        let newWidth = base.size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, base.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// SwifterSwift: UIImage scaled to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / base.size.width
        let newHeight = base.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, base.scale)
        base.draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    /// SwifterSwift: Creates a copy of the receiver rotated by the given angle (in radians).
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: .pi)
    ///
    /// - Parameter radians: The angle, in radians, by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: base.size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, base.scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        base.draw(in: CGRect(origin: CGPoint(x: -base.size.width / 2,
                                             y: -base.size.height / 2),
                             size: base.size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


@available(iOS 10.0, *)
public extension ExtWrapper where Base: UIImage {

    static func generateQRCode(qrString: String, centerText: String?, size: CGFloat) -> UIImage? {
        let data = qrString.data(using: .utf8)

        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue("H", forKey: "inputCorrectionLevel")

        guard let qrImage = qrFilter.outputImage else { return nil }
        let scaleX = size / qrImage.extent.size.width
        let scaleY = size / qrImage.extent.size.height
        let transformedImage = qrImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        let render = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        let image = render.image { context in
            UIImage(ciImage: transformedImage).draw(in: CGRect(origin: .zero, size: CGSize(width: size, height: size)))

            if let centerText = centerText {
                let font = UIFont.boldSystemFont(ofSize: 20)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: paragraphStyle
                ]
                let textSize = centerText.size(withAttributes: attributes)
                let textRect = CGRect(x: (size - textSize.width) / 2, y: (size - textSize.height) / 2, width: textSize.width, height: textSize.height)

                // 将中心区域挖空
                UIColor.white.setFill()
                context.fill(textRect)

                // 绘制中心文本
                centerText.draw(in: textRect, withAttributes: attributes)
            }
        }

        return image
    }
}
