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
    func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
                   radius: CGFloat = 3,
                   offset: CGSize = .zero,
                   opacity: Float = 0.5)
    {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowOffset = offset
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = opacity
        base.layer.masksToBounds = false
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
            shapeLayer.path = UIBezierPath(roundedRect: gradientLayer.bounds, cornerRadius: cornerRadius).cgPath
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

    /// 将当前坐标系的点转换到另一个视图或窗口的坐标系
    ///
    /// 当参数view为nil的时候，系统会自动帮你转换为当前窗口的基本坐标系（即view参数为整个屏幕，原点为(0,0)，宽高是屏幕的宽高）
    ///
    /// 计算公式：
    ///
    /// 1.如果`fromView`和`toView`不为`superView`关系
    ///
    /// ```
    /// (fromView.frame.origin - fromView.bounds.origin) + point - (toView.frame.origin - toView.bounds.origin)
    /// ```
    ///
    /// 2.如果'fromView'和'toView'有任何一方为另一方的'superView'，该view不再参与计算。
    /// ```
    /// [fromView addSubview:toView]; //即fromView为superView时
    /// ==> result = point - (toView.frame.origin - toView.bounds.origin)
    ///
    /// [toView addSubview:fromView]; //即toView为superView时
    /// ==> result = (fromView.frame.origin - fromView.bounds.origin) + point
    /// ```
    ///
    /// - Parameters:
    ///   - point: 当前视图坐标系的点
    ///   - view: 指定视图或窗口
    ///   - Returns: 转换坐标系后的点坐标
    func convertPoint(point: CGPoint, toViewOrWindow view: UIView?) -> CGPoint {
        guard let view = view else {
            if base.isKind(of: UIWindow.self) {
                return (base as! UIWindow).convert(point, to: nil)
            } else {
                return base.convert(point, to: nil)
            }
        }
        if let from = base.isKind(of: UIWindow.self) ? (base as! UIWindow) : base.window,
           let to = view.isKind(of: UIWindow.self) ? (view as! UIWindow) : view.window, from != to
        {
            var p = point
            p = base.convert(p, to: from)
            p = to.convert(p, to: from)
            p = view.convert(p, to: to)
            return p
        } else {
            return base.convert(point, to: view)
        }
    }

    /// 将一个点从一个指定视图或窗口的坐标系转换到当前视图坐标系
    ///
    /// 当参数view为nil的时候，系统会自动帮你转换为当前窗口的基本坐标系（即view参数为整个屏幕，原点为(0,0)，宽高是屏幕的宽高）
    ///
    /// 计算公式：
    ///
    /// 1.如果`fromView`和`toView`不为`superView`关系
    ///
    /// ```
    /// (fromView.frame.origin - fromView.bounds.origin) + point - (toView.frame.origin - toView.bounds.origin)
    /// ```
    ///
    /// 2.如果'fromView'和'toView'有任何一方为另一方的'superView'，该view不再参与计算。
    /// ```
    /// [fromView addSubview:toView]; //即fromView为superView时
    /// ==> result = point - (toView.frame.origin - toView.bounds.origin)
    ///
    /// [toView addSubview:fromView]; //即toView为superView时
    /// ==> result = (fromView.frame.origin - fromView.bounds.origin) + point
    /// ```
    ///
    /// - Parameters:
    ///   - point: 当前视图坐标系的点
    ///   - view: 指定视图或窗口
    ///   - Returns: 转换坐标系后的点坐标
    func convertPoint(point: CGPoint, fromViewOrWindow view: UIView?) -> CGPoint {
        guard let view = view else {
            if base.isKind(of: UIWindow.self) {
                return (base as! UIWindow).convert(point, from: nil)
            } else {
                return base.convert(point, from: nil)
            }
        }

        if let from = view.isKind(of: UIWindow.self) ? (view as! UIWindow) : view.window,
           let to = base.isKind(of: UIWindow.self) ? (base as! UIWindow) : base.window, from != to
        {
            var p = point
            p = from.convert(p, from: view)
            p = to.convert(p, from: from)
            p = base.convert(p, from: to)
            return p
        } else {
            return base.convert(point, from: nil)
        }
    }

    /// 将一个矩形区域从当前视图坐标系转换到指定视图或窗口坐标系
    ///
    /// 使用方法：
    /// ```
    /// CGRect rect = [_button.superview convertRect:_button.frame toViewOrWindow:self.view];
    /// ```
    ///
    /// button的frame是相对于其superview来确定的，frame确定了button在其superview的位置和大小
    ///
    /// 一般来说，toView方法中，消息的接收者为被转换的frame所在的控件的superview；fromView方法中，消息的接收者为即将转到的目标view.
    ///
    /// - Parameters:
    ///   - rect: 矩形区域
    ///   - view: 指定视图或窗口
    /// - Returns: 目标坐标系的矩形区域
    func convertRect(rect: CGRect, toViewOrWindow view: UIView?) -> CGRect {
        guard let view = view else {
            if base.isKind(of: UIWindow.self) {
                return (base as! UIWindow).convert(rect, to: nil)
            } else {
                return base.convert(rect, to: nil)
            }
        }

        if let from = base.isKind(of: UIWindow.self) ? (base as! UIWindow) : base.window,
           let to = view.isKind(of: UIWindow.self) ? (view as! UIWindow) : view.window, from != to
        {
            var r = rect
            r = base.convert(r, to: from)
            r = to.convert(rect, to: from)
            r = view.convert(rect, to: to)
            return r
        } else {
            return base.convert(rect, to: view)
        }
    }

    /// 将一个矩形区域从指定视图坐标系转换到当前视图或窗口坐标系
    ///
    /// 使用方法：
    /// ```
    /// CGRect rect = [self.view convertRect:_button.frame fromViewOrWindow:_button.superview];
    /// ```
    ///
    /// button的frame是相对于其superview来确定的，frame确定了button在其superview的位置和大小
    ///
    /// 一般来说，toView方法中，消息的接收者为被转换的frame所在的控件的superview；fromView方法中，消息的接收者为即将转到的目标view.
    ///
    /// - Parameters:
    ///   - rect: 矩形区域
    ///   - view: 指定视图或窗口
    /// - Returns: 当前坐标系的矩形区域
    func convertRect(rect: CGRect, fromViewOrWindow view: UIView?) -> CGRect {
        guard let view = view else {
            if base.isKind(of: UIWindow.self) {
                return (base as! UIWindow).convert(rect, from: nil)
            } else {
                return base.convert(rect, from: nil)
            }
        }

        if let from = view.isKind(of: UIWindow.self) ? (view as! UIWindow) : view.window,
           let to = base.isKind(of: UIWindow.self) ? (base as! UIWindow) : base.window, from != to
        {
            var r = rect
            r = from.convert(r, from: view)
            r = to.convert(r, from: from)
            r = base.convert(r, from: to)
            return r
        } else {
            return base.convert(rect, from: view)
        }
    }
}
