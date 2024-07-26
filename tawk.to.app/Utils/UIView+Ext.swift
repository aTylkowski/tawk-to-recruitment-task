//
//  UIView+Ext.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    func addCornerRadius(_ radius: CGFloat = 8) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
