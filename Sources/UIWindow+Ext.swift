//
//  UIWindow+Ext.swift
//  DouYinSwift5
//
//  Created by lym on 2020/7/23.
//  Copyright © 2020 lym. All rights reserved.
//
import UIKit

public extension ExtWrapper where Base: UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.connectedScenes
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .first?.windows
                .filter { $0.isKeyWindow }.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIWindow.ext.key?.safeAreaInsets ?? .zero
        } else {
            return .zero
        }
    }

    static var statusBarFrame: CGRect {
        if #available(iOS 13.0, *) {
            return key?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            return UIApplication.shared.statusBarFrame
        }
    }

    static var statusBarHeight: CGFloat {
        return statusBarFrame.size.height
    }

    static var navBarHeight: CGFloat {
        return topController()?.navigationController?.navigationBar.frame.height ?? 44
    }

    static var navBarSafeAreaHeight: CGFloat {
        return statusBarHeight + navBarHeight
    }

    static var tabBarFrame: CGRect {
        if let vc = key?.rootViewController as? UITabBarController {
            if #available(iOS 11.0, *) {
                return vc.tabBar.frame
            } else {
                return .zero
            }
        } else {
            return .zero
        }
    }

    static var tabBarSafeAreaHeight: CGFloat {
        return tabBarFrame.height
    }

    static var tabBarHeight: CGFloat {
        if #available(iOS 11.0, *) {
            return tabBarSafeAreaHeight - (key?.safeAreaInsets.bottom ?? 0)
        } else {
            return tabBarSafeAreaHeight
        }
    }

    static func topController(_ base: UIViewController? = key?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topController(nav.viewControllers.last)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topController(selected)
        }
        return base
    }

    /// SwifterSwift: Switch current root view controller with a new view controller.
    ///
    /// - Parameters:
    ///   - viewController: new view controller.
    ///   - animated: set to true to animate view controller change (default is true).
    ///   - duration: animation duration in seconds (default is 0.5).
    ///   - options: animation options (default is .transitionFlipFromRight).
    ///   - completion: optional completion handler called after view controller is changed.
    func switchRootViewController(
        to viewController: UIViewController,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        options: UIView.AnimationOptions = .transitionFlipFromRight,
        _ completion: (() -> Void)? = nil
    ) {
        guard animated else {
            base.rootViewController = viewController
            completion?()
            return
        }

        UIView.transition(with: base, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            base.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }
}

extension UIScreen: ExtCompatible {}

public extension ExtWrapper where Base: UIScreen {
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
}

extension UIDevice: ExtCompatible {}

public extension ExtWrapper where Base: UIDevice {
    static var isIphoneX: Bool {
        if UIDevice.current.userInterfaceIdiom != .phone {
            return true
        }
        if #available(iOS 11.0, *) {
            let bottom = UIWindow.ext.safeAreaInsets.bottom
            if bottom > 0.0 {
                return true
            }
        }
        return false
    }
}
