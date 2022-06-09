//
//  UIListController.swift
//  YMExtension_Example
//
//  Created by lym on 2022/2/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import YMExtension

let NotificationName = NSNotification.Name("1")

class UIListController: UITableViewController {
    let datas = ["渐变色按钮"]
    let vcs: [UIViewController] = [TableController()]

    override func viewDidLoad() {
        super.viewDidLoad()

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
        navigationController?.pushViewController(vcs[indexPath.row], animated: true)
        if indexPath.row == 0 {
            NotificationCenter.default.post(name: NotificationName, object: ["1","2","3"], userInfo: ["k": "v"])
        }
    }
}
