//
//  UIView+Ext.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//

import UIKit

extension UIView: ExtCompatible {}

/// 屏幕适配：按屏幕宽度计算
public func adaptWidth(designWidth: CGFloat = 375.0, _ vale: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.size.width / designWidth * vale
}

public extension ExtWrapper where Base == UIView {
    /// 返回视图的控制器对象
    func viewController() -> UIViewController? {
        var view: UIView? = base
        repeat {
            if let nextResponder = view?.next {
                if nextResponder.isKind(of: UIViewController.self) {
                    return nextResponder as? UIViewController
                }
            }
            view = view?.superview
        } while view != nil

        return nil
    }

    /// 添加阴影
    func addShadow(shadowColor: UIColor,
                   opacity: Float = 0.5,
                   offset: CGSize,
                   radius: CGFloat,
                   scale _: Bool = true)
    {
        base.layer.masksToBounds = false
        base.layer.shadowColor = shadowColor.cgColor
        base.layer.shadowOffset = offset
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = opacity
    }

    @discardableResult
    /// 添加渐变背景
    func addGradientColor(startPoint: CGPoint,
                          endPoint: CGPoint,
                          locs: [NSNumber] = [0, 1],
                          colors: [Any],
                          cornerRadius: CGFloat = 0) -> CAGradientLayer?
    {
        guard startPoint.x >= 0,
              startPoint.x <= 1,
              startPoint.y >= 0,
              startPoint.y <= 1,
              endPoint.x >= 0,
              endPoint.x <= 1,
              endPoint.y >= 0,
              endPoint.y <= 1
        else {
            return nil
        }
        base.layoutIfNeeded()
        var gradientLayer: CAGradientLayer!
        removeGradientLayer()
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = base.layer.bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = base.layer.cornerRadius
        gradientLayer.masksToBounds = true
        gradientLayer.locations = locs
        if cornerRadius > 0 {
            let shapeLayer = CAShapeLayer()
            shapeLayer.borderWidth = 1
            shapeLayer.path = UIBezierPath(roundedRect: gradientLayer.bounds,
                                           cornerRadius: cornerRadius).cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor // 必须要设置成clearColor或者nil，默认是黑色
            shapeLayer.strokeColor = UIColor.white.cgColor // 随便设置一个非clearColor的颜色
            gradientLayer.mask = shapeLayer
        }
        // 渐变图层插入到最底层，避免在uibutton上遮盖文字图片
        base.layer.insertSublayer(gradientLayer, at: 0)
        base.backgroundColor = UIColor.clear
        // self如果是UILabel，masksToBounds设为true会导致文字消失
        // layer.masksToBounds = false
        return gradientLayer
    }

    /// 移除渐变layer
    func removeGradientLayer() {
        if let sublayers = base.layer.sublayers {
            for layer in sublayers {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}
