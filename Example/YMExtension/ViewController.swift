//
//  ViewController.swift
//  YMExtension
//
//  Created by lym on 11/24/2021.
//  Copyright (c) 2021 lym. All rights reserved.
//

import UIKit
import YMExtension

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.ext.random;
        
        print(Bundle.ext.appBundleName)
        print(Bundle.ext.appVersion)
        print(UIWindow.ext.safeAreaInsets)
        print(UIWindow.ext.statusBarFrame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

