//
//  UserCell.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 23/07/2024.
//

import UIKit

final class UserCell: BaseCell {
    private let stackViewContainer: UIStackView = {
        let stackViewContainer = UIStackView()
        stackViewContainer.spacing = Size.base3
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        return stackViewContainer
    }()

    private let leftImageViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.poppinsSemiBold(size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let rightImageViewContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let rightImageView: UIImageView = {
        let image: UIImage = .note
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override func setupProperties() {
        addSubview(stackViewContainer)
        leftImageViewContainer.addSubview(leftImageView)
        rightImageViewContainer.addSubview(rightImageView)
    }

    override func setupConstraints() {
        stackViewContainer.constraintEdges(to: self, insets: UIEdgeInsets(top: 0, left: Size.base2, bottom: 0, right: Size.base2))
        stackViewContainer.addArrangedSubviews([leftImageViewContainer, nameLabel, spacerView, rightImageViewContainer])

        leftImageView.constraintEdges(to: leftImageViewContainer, insets: UIEdgeInsets(top: Size.base2, left: 0, bottom: Size.base2, right: 0))
        leftImageView.constraintSize(width: Size.base6, height: Size.base6)

        rightImageView.constraint(to: rightImageViewContainer, edges: [.leading, .trailing, .centerY])
    }

    func configure(data: UserInfo) {
        nameLabel.text = data.username
        nameLabel.textColor = data.isSeen == true ? .gray : .black
        rightImageViewContainer.isHidden = data.bio?.isEmpty ?? true
        if let url = URL(string: data.profileImageUrl) {
            let isInverted = data.isInverted ?? false
            leftImageView.setImage(from: url, placeholder: UIImage(named: "placeholder"), isInverted: isInverted)
        }
    }
}
