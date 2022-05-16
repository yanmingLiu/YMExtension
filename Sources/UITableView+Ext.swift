//
//  UITableView+Ext.swift
//  DouYinSwift5
//
//  Created by lym on 2021/6/8.
//  Copyright © 2021 lym. All rights reserved.
//

import UIKit

public extension ExtWrapper where Base: UITableView {
    /// Set table header view & add Auto layout.
    func setTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Set first.
        base.tableHeaderView = headerView

        // Then setup AutoLayout.
        headerView.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: base.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: base.topAnchor).isActive = true

        updateHeaderViewFrame()
    }

    /// Update header view's frame.
    func updateHeaderViewFrame() {
        guard let headerView = base.tableHeaderView else { return }

        // Update the size of the header based on its internal content.
        headerView.layoutIfNeeded()

        // ***Trigger table view to know that header should be updated.
        let header = base.tableHeaderView
        base.tableHeaderView = header
    }
}
