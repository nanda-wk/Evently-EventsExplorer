//
//  SearchViewController.swift
//  Evently-EventsExplorer
//
//  Created by Nanda WK on 2025-07-24.
//

import SwiftUI
import UIKit

class SearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let noResultsLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private let viewModel: SearchViewModel
    let container: DIContainer

    private var searchTask: DispatchWorkItem?

    init(container: DIContainer) {
        self.container = container
        viewModel = .init(container: container)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.updateView()
            }
        }

        Task {
            await viewModel.loadEvents()
        }
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
        searchBar.placeholder = "Search by event or city"
        searchBar.searchTextField.addTarget(self, action: #selector(searchBarTextChanged), for: .editingChanged)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        noResultsLabel.text = "No events found"
        noResultsLabel.textAlignment = .center
        noResultsLabel.textColor = .gray
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noResultsLabel)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func updateView() {
        tableView.reloadData()
        noResultsLabel.isHidden = !viewModel.isEventListEmpty
        tableView.isHidden = viewModel.isEventListEmpty || (viewModel.isFetching && viewModel.events.isEmpty)

        if viewModel.isFetching, viewModel.events.isEmpty {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    @objc private func searchBarTextChanged() {
        searchTask?.cancel()

        let query = (searchBar.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.keyword = query

        let task = DispatchWorkItem { [weak self] in
            guard let self else { return }

            Task {
                await self.viewModel.loadEvents(reset: true)
            }
        }

        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = viewModel.event(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.contentConfiguration = UIHostingConfiguration(content: {
            EventCell(event: event)
        })

        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection _: Int) -> UIView? {
        if viewModel.isFetching, !viewModel.events.isEmpty {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.center = footerView.center
            footerView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            return footerView
        } else {
            return nil
        }
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        (viewModel.isFetching && !viewModel.events.isEmpty) ? 50 : 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let event = viewModel.event(at: indexPath.row)

        let detailView = EventDetail(viewModel: .init(container: container, event: event))

        let hostingController = UIHostingController(rootView: detailView)

        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfRows() - 1 {
            Task {
                await viewModel.loadEvents()
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
