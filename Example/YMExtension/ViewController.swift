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
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.ext.register(cellWithClass: UITableViewCell.self)
        return tableView
    }()

    var headerView: UIView!

    var datas = [String]()

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.frame = CGRect(
            x: 0,
            y: UIWindow.ext.navBarSafeAreaHeight,
            width: view.bounds.width,
            height: view.bounds.height - UIWindow.ext.navBarSafeAreaHeight - UIWindow.ext.tabBarSafeAreaHeight)

        tableHeaderViewLayout()

        let url = URL(string: "https://google.com?")!
        let param = ["lang": "en"]
        let res1 = url.ext.appendingQueryParameters(param)
        let res2 = res1.ext.appendingQueryParameters(["lang": "id"])
        print(res1)
        print(res2)

        NotificationCenter.default.ext.observeOnce(forName: .onceNotificationDemo) { notification in
            let object = notification.object as? [String]
            let userInfo = notification.userInfo as? [String: Any]
            print(object)
            print(userInfo)
        }

        UserDefaults.standard.ext.set(object: 0.12, forKey: "float")
        UserDefaults.standard.ext.set(object: "字符串", forKey: "string")
        let number = UserDefaults.standard.ext.object(Float.self, with: "float") ?? 0
        let string = UserDefaults.standard.ext.object(String.self, with: "string") ?? ""
        print("number = \(number), string = \(string)")

        var arr = [1, 2, 3, 4, 5]
        arr.safeSwap(from: 3, to: 0)
        print(arr)
    }

    private func tableHeaderViewLayout() {
        let view = UIView()
        view.backgroundColor = UIColor.ext.random()

        let label = UILabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.ext.width - 40
        label.text = """

         TableHeaderViewLayout自动高度\n\n
        iOS is the world’s most advanced mobile operating system.
        With iOS 15, you can build apps that connect people in new ways with SharePlay,
        help them focus on the moment with new notification APIs,
        and provide new tools for exploring with augmented reality,
        Safari extensions, and nearby interactions.
        You can even improve the discovery of your app on the App Store,
        provide better in-app purchase experiences,
        and more with the latest capabilities for apps on the App Store.
        """

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        // 动态高度
        tableView.ext.setTableHeaderView(headerView: view)

        headerView = view
    }

    private func extText() -> String? {

        """
        常用扩展：
        Bundle.ext.appBundleName = \(Bundle.ext.appBundleName)
        Bundle.ext.appVersion = \(Bundle.ext.appVersion)
        UIDevice.ext.isIphoneX = \(UIDevice.ext.isIphoneX)

        UIWindow.ext.key = \(String(describing: UIWindow.ext.key))
        UIWindow.ext.safeAreaInsets = \(UIWindow.ext.safeAreaInsets)
        UIWindow.ext.statusBarHeight = \(UIWindow.ext.statusBarHeight)
        UIWindow.ext.navBarHeight = \(UIWindow.ext.navBarHeight)
        UIWindow.ext.navBarSafeAreaHeight = \(UIWindow.ext.navBarSafeAreaHeight)

        UIWindow.ext.tabBarFrame = \(UIWindow.ext.tabBarFrame)
        UIWindow.ext.tabBarHeight = \(UIWindow.ext.tabBarHeight)
        UIWindow.ext.tabBarSafeAreaHeight = \(UIWindow.ext.tabBarSafeAreaHeight)

        随机6位数的字符串String.ext.randomString(6)) = \(String.ext.random(ofLength: 6))
        """
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ext.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.textLabel?.numberOfLines = 0

        if indexPath.row == 0 {
            cell.textLabel?.text = extText()
        }
        cell.contentView.backgroundColor = UIColor.ext.random()
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        var value = 0
        let delay = 0.02
        let debouncedIncrementor = DispatchQueue.main.ext.debounce(delay: delay) {
            value += 1
            print("value = \(value)")
        }
        for _ in 1 ... 10 {
            debouncedIncrementor()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            print("防抖动结束 value = \(value)")
        }
    }
}
