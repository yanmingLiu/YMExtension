//
//  UIListController.swift
//  YMExtension_Example
//
//  Created by lym on 2022/2/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import YMExtension

enum appNotiName: String {
    case onceNotificationDemo
}

extension Notification.Name  {
    static let onceNotificationDemo = NSNotification.Name(appNotiName.onceNotificationDemo.rawValue)
}

class UIListController: UITableViewController {
    let datas = ["渐变色按钮",
                 "输入框防抖",
                 "DynamicTableHeaderView",
                 "二维码图片",
    ]
    let vcs: [String] = ["TableController",
                         "TextViewController",
                         "TableViewController",
                         "QRController",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        tableView.ext.register(cellWithClass: UITableViewCell.self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ext.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = datas[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcName = vcs[indexPath.row]
        guard let vcClass = vcName.ext.toClass() as? UIViewController.Type else {
            return
        }
        let vc = vcClass.init()
        navigationController?.pushViewController(vc, animated: true)
        NotificationCenter.default.post(name: .onceNotificationDemo, object: ["1","2","3"], userInfo: ["k": "v"])
    }
}
