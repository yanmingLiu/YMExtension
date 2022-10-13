//
//  TextViewController.swift
//  YMExtension_Example
//
//  Created by lym on 2022/10/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 16
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.delegate = self
        return textView
    }()

    var debouncedAction: (() -> Void)?

    deinit {
        print("deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIWindow.ext.navBarSafeAreaHeight).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        debouncedAction = DispatchQueue.main.ext.debounce(delay: 1.5) { [weak self] in
            self?.search()
        }
    }

    func search() {
        print(self.textView.text ?? "")
    }
}

extension TextViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

        debouncedAction?()
    }
}
