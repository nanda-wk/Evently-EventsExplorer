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

    let viewModel: SearchViewModel
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
                self?.tableView.reloadData()
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
        navigationItem.titleView = searchBar

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
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

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = viewModel.event(at: indexPath.row)

        let detailView = EventDetail(event: event)

        let hostingController = UIHostingController(rootView: detailView)

        if let navigationController {
            navigationController.pushViewController(hostingController, animated: true)
            navigationController.setNavigationBarHidden(true, animated: true)
        } else {
            present(hostingController, animated: true, completion: nil)
        }
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
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
