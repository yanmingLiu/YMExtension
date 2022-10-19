//
//  TableController.swift
//  SwiftDemo
//
//  Created by lym on 2022/6/2.
//

import Foundation
import UIKit
import YMExtension

let firstColor = UIColor(red: 0/255.0, green: 185/255.0, blue: 172/255.0, alpha: 1)
let secondColor = UIColor(red: 86/255.0, green: 126/255.0, blue: 177/255.0, alpha: 1)
let colors0 = [firstColor, secondColor]

let colors = [UIColor.ext.hex("#7B47FF"),
              UIColor.ext.hex("#8D68F2")]

class TableController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.ext.register(cellWithClass: TableCell.self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ext.dequeueReusableCell(withClass: TableCell.self, for: indexPath)
        let count = indexPath.row + 3
        let random = String.ext.random(ofLength: count)
        cell.actionButton.setTitle("渐变色" + random, for: .normal)
        cell.leftLabel.text = random
        return cell
    }
}

class TableCell: UITableViewCell {
    let actionButton = UIButton()
    let leftLabel = UILabel()

    private var labelGradientLayer: CAGradientLayer?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        contentView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        actionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        actionButton.layer.cornerRadius = 4
        actionButton.clipsToBounds = true

        contentView.addSubview(leftLabel)
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -20).isActive = true
        leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        leftLabel.layer.cornerRadius = 8

        let image = UIImage.ext.gradientColorImage(colors: colors0)
        actionButton.setBackgroundImage(image, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if labelGradientLayer?.frame != bounds {
            labelGradientLayer?.frame = bounds
            labelGradientLayer = leftLabel.ext.addGradientColor(startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5), colors: colors)
        }
    }
}
