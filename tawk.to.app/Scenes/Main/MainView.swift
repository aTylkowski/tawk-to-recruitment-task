//
//  MainView.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import UIKit

final class MainView: BaseView {
    private let searchView: SearchBarView = {
        let searchView = SearchBarView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        return searchView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = PlaceholderType.initial.title
        label.textColor = .black
        label.font = UIFont.poppinsBold(size: 18)
        label.numberOfLines = 0
        return label
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let refreshControl = UIRefreshControl()

    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    let searchModeButton: UIButton = {
        let searchModeButton = UIButton(type: .system)
        searchModeButton.setTitle("Search mode: \(SearchType.remote.title)", for: .normal)
        searchModeButton.titleLabel?.font = .poppinsMedium(size: 9)
        searchModeButton.translatesAutoresizingMaskIntoConstraints = false
        searchModeButton.setTitleColor(.white, for: .normal)
        searchModeButton.backgroundColor = .black
        searchModeButton.addCornerRadius()
        return searchModeButton
    }()

    let noWifiImageView: UIImageView = {
        let noWifiImageView = UIImageView(image: .noWifi)
        noWifiImageView.translatesAutoresizingMaskIntoConstraints = false
        noWifiImageView.isHidden = true
        return noWifiImageView
    }()

    lazy var searchTextField: UITextField = searchView.textField
    lazy var searchCancelButton: UIButton = searchView.cancelButton

    override func setupProperties() {
        addSubview(searchView)
        addSubview(tableView)
        addSubview(activityIndicator)
        addSubview(searchModeButton)
        addSubview(noWifiImageView)

        tableView.separatorStyle = .none
        tableView.backgroundView = placeholderLabel
        tableView.refreshControl = refreshControl
    }

    override func setupConstraints() {
        searchView.constraint(to: self, edges: [.topGuide, .leading, .trailing])
        searchView.constraintHeight(to: Size.base5)

        tableView.constraintEdges(to: self, excluding: [.top])
        tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10).isActive = true

        activityIndicator.constraint(to: self, edges: [.centerX, .bottomGuide], insets: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))

        searchModeButton.constraint(to: tableView, edges: [.top, .trailing], insets: UIEdgeInsets(top: Size.base3, left: 0, bottom: 0, right: Size.base3))
        searchModeButton.constraintWidth(to: 120)

        noWifiImageView.constraint(to: tableView, edges: [.top, .trailing], insets: UIEdgeInsets(top: Size.base7, left: 0, bottom: 0, right: Size.base7))
    }

    func updatePlaceholder(text: String) {
        if text.isEmpty {
            tableView.backgroundView = nil
        } else {
            placeholderLabel.text = text
            tableView.backgroundView = placeholderLabel
        }
    }
}
