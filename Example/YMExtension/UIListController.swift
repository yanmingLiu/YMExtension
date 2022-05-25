//
//  UIListController.swift
//  YMExtension_Example
//
//  Created by lym on 2022/2/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import YMExtension

class UIListController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(frame: CGRect(x: 20, y: UIWindow.ext.navBarSafeAreaHeight + 50, width: UIScreen.ext.width - 40, height: 40))
        btn.setTitle("渐变色按钮", for: .normal)
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        view.addSubview(btn)

        let colors = [UIColor.ext.hexString("#8E28FF").cgColor,
                      UIColor.ext.hexString("#3F03FF").cgColor]
        let image = UIImage.ext.gradientColorImage(bounds: btn.bounds, colors: colors)
        btn.setBackgroundImage(image, for: .normal)
    }
}
