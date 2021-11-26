//
//  ViewController.swift
//  YMExtension
//
//  Created by lym on 11/24/2021.
//  Copyright (c) 2021 lym. All rights reserved.
//

import UIKit
import YMExtension

extension UITabBarController{
    
    func getHeight()->CGFloat{
        return self.tabBar.frame.size.height
    }
    
    func getWidth()->CGFloat{
        return self.tabBar.frame.size.width
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(Bundle.ext.appBundleName)
        print(Bundle.ext.appVersion)
        print("window: \(UIWindow.ext.key)")
        print("safeAreaInsets:\(UIWindow.ext.safeAreaInsets)")
        print("statusBarHeight: \(UIWindow.ext.statusBarHeight)")
        print("navBarSafeAreaHeight: \(UIWindow.ext.navBarSafeAreaHeight)")
        
        print("tabBar.frame:\(UIWindow.ext.tabBarFrame)")
        print("tabBarHeight:\(UIWindow.ext.tabBarHeight)")
        print("tabBarSafeAreaHeight:\(UIWindow.ext.tabBarSafeAreaHeight)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            print("view.safeAreaInsets:\(self.view.safeAreaInsets)")
        } else {
            // Fallback on earlier versions
        }
        print("view.frame:\(self.view.frame)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

