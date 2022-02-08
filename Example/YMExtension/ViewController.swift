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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var headerView: UIView!

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Demo"

        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: UIWindow.ext.navBarSafeAreaHeight, width: view.bounds.width, height: view.bounds.height - UIWindow.ext.navBarSafeAreaHeight - UIWindow.ext.tabBarSafeAreaHeight)

        tableHeaderViewLayout()

        print("appBundleName: \(Bundle.ext.appBundleName)")
        print("appVersion:\(Bundle.ext.appVersion)")
        print("window: \(String(describing: UIWindow.ext.key))")
        
        print("safeAreaInsets:\(UIWindow.ext.safeAreaInsets)")
        print("statusBarHeight: \(UIWindow.ext.statusBarHeight)")
        print("navBarHeight: \(UIWindow.ext.navBarHeight)")
        print("navBarSafeAreaHeight: \(UIWindow.ext.navBarSafeAreaHeight)")

        print("tabBar.frame:\(UIWindow.ext.tabBarFrame)")
        print("tabBarHeight:\(UIWindow.ext.tabBarHeight)")
        print("tabBarSafeAreaHeight:\(UIWindow.ext.tabBarSafeAreaHeight)")
        
        let json = "{\"greeting\": \"Welcome to quicktype!\"}"
        let dic = json.ext.toDictionary()
        print(dic as! [String: String])
        
        print("随机6位数的字符串:\(String.ext.randomString(6))")
        
        let point = headerView.ext.convertRect(rect: headerView.bounds, toViewOrWindow: UIWindow.ext.key)
        print("headerView的frame:\(headerView.frame)")
        print("headerView的坐标转到window:\(point)")
    }

    private func tableHeaderViewLayout() {
        let view = UIView()
        view.backgroundColor = UIColor.ext.random

        let label = UILabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.ext.width - 40
        label.text = "iOS is the world’s most advanced mobile operating system. With iOS 15, you can build apps that connect people in new ways with SharePlay, help them focus on the moment with new notification APIs, and provide new tools for exploring with augmented reality, Safari extensions, and nearby interactions. You can even improve the discovery of your app on the App Store, provide better in-app purchase experiences, and more with the latest capabilities for apps on the App Store."

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

    @IBAction func jump(_: Any) {}
}

extension ViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
