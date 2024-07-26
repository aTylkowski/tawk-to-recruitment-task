//
//  BaseCell.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 23/07/2024.
//

import UIKit

class BaseCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupProperties()
        setupConstraints()
    }

    func setupProperties() { }

    func setupConstraints() { }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
