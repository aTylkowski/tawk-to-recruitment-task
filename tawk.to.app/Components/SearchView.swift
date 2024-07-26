//
//  SearchView.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import UIKit

final class SearchBarView: BaseView {
    private let magnifierImageView: UIImageView = {
        let magnifierImageView = UIImageView(image: .magnifier)
        magnifierImageView.tintColor = .black
        magnifierImageView.translatesAutoresizingMaskIntoConstraints = false
        return magnifierImageView
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.cancel, for: .normal)
        button.tintColor = .black
        return button
    }()

    let textField = UITextField()

    override func setupConstraints() {
        addSubviews([magnifierImageView,
                     textField,
                     cancelButton])

        magnifierImageView.constraint(to: self,
                                      edges: [.centerY, .left],
                                      insets: UIEdgeInsets(top: 0, left: Size.base2, bottom: 0, right: 0))
        magnifierImageView.constraintWidth(to: Size.base4)

        textField.leadingAnchor.constraint(equalTo: magnifierImageView.trailingAnchor, constant: 5).isActive = true
        textField.constraint(to: self, edges: [.top, .bottom])
        textField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor).isActive = true

        cancelButton.constraint(to: self,
                                edges: [.top, .bottom, .centerY, .trailing],
                                insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Size.base2))
        cancelButton.constraintWidth(to: Size.base4)
    }

    override func setupProperties() {
        backgroundColor = .white
        addCornerRadius(Size.base2)

        magnifierImageView.contentMode = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray
        ]
        textField.tintColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: attributes)
    }
}
