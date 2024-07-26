//
//  MainViewController.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import UIKit

final class MainViewController: UIViewController {
    private let mainView = MainView()
    private let viewModel = MainViewModel()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchEntryUsers()
    }

    private func setupUI() {
        mainView.searchTextField.delegate = self

        mainView.tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.defaultReuseIdentifier)
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self

        mainView.refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

        mainView.searchCancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)

        mainView.searchModeButton.addTarget(self, action: #selector(didTapSearchModeButton), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] in
            self?.reloadData()
        }

        viewModel.onPlaceholderUpdated = { [weak self] text in
            self?.updatePlaceholder(text: text)
        }

        viewModel.onNetworkAvailable = { [weak self] isAvailable in
            self?.mainView.noWifiImageView.isHidden = isAvailable
            guard isAvailable else { return }
            self?.viewModel.getUsersList(phrase: self?.mainView.searchTextField.text ?? "")
        }
    }
}

// MARK: Search - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            viewModel.currentPage = 1
            mainView.activityIndicator.startAnimating()
            viewModel.getUsersList(phrase: updatedText)
        }
        return true
    }
}

// MARK: Users List - UITableViewDelegate & UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.defaultReuseIdentifier) as? UserCell else { return UITableViewCell() }
        cell.configure(data: viewModel.users[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.users[indexPath.row].isSeen = true
        let username = viewModel.users[indexPath.row].username
        let viewModel = ProfileViewModel(username: username)
        let profileView = ProfileView(viewModel: viewModel)
        let viewController = SwiftUIViewController(swiftUIView: profileView)
        present(viewController, animated: true) { [weak self] in
            self?.reloadData()
        }
    }

    private func reloadData() {
        mainView.tableView.reloadData()
        mainView.refreshControl.endRefreshing()
        mainView.activityIndicator.stopAnimating()
    }

    private func updatePlaceholder(text: String) {
        mainView.updatePlaceholder(text: text)
    }
}

// MARK: Users List - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > 0,
           offsetY > contentHeight - scrollView.frame.height,
           let phrase = mainView.searchTextField.text, !viewModel.isFetching {
            mainView.activityIndicator.startAnimating()
            viewModel.getUsersList(phrase: phrase)
        }
    }
}

// MARK: Users List - UIRefreshControl

extension MainViewController {
    @objc private func didPullToRefresh() {
        guard !viewModel.isFetching else { return }
        mainView.refreshControl.beginRefreshing()
        viewModel.getUsersList(phrase: mainView.searchTextField.text ?? "")
    }
}

// MARK: Search - Cancel Button & Search Mode Button

extension MainViewController {
    @objc private func didTapCancelButton() {
        mainView.searchTextField.text = ""
        viewModel.fetchEntryUsers()
    }

    @objc private func didTapSearchModeButton() {
        viewModel.toggleSearchType(text: mainView.searchTextField.text ?? "")
        mainView.searchModeButton.setTitle("Search mode: \(viewModel.searchType.title)", for: .normal)
    }
}
