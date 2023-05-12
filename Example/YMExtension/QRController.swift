//
//  QRController.swift
//  YMExtension_Example
//
//  Created by lym on 2023/5/12.
//  Copyright © 2023 CocoaPods. All rights reserved.
//
import UIKit
import YMExtension

class QRController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let imageView = UIImageView()
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])

        let imgae = UIImage.ext.generateQRCode(qrString: "https://www.baidu.com", centerText: "BAIDU", size: 200)
        imageView.image = imgae
    }
}
