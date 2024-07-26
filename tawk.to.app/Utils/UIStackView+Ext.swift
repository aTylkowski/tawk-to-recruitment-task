//
//  UIStackView+Ext.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 23/07/2024.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach(addArrangedSubview)
    }
}
