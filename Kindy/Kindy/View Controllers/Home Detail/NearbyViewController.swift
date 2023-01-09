//
//  NearbyViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/19.
//

import UIKit

final class NearbyViewController: UIViewController, UISearchResultsUpdating {

    // MARK: - 파이어베이스 Task

    private var imageRequestTask: Task<Void, Never>?

    deinit {
        imageRequestTask?.cancel()
    }

    // MARK: - 프로퍼티

    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white

        return tableView
    }()

    private var filteredItems: [Bookstore] = []
    private var receivedData: [Bookstore] = []

    private let searchController = UISearchController()

    // MARK: - 라이프 사이클

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        setupCustomCancelButton(of: searchController)
        setupTableView()
        dismissKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "내 주변 서점"

        navigationController?.setNavigationBarHidden(false, animated: false)

        let customNavBarAppearance = UINavigationBarAppearance()
        customNavBarAppearance.backgroundColor = .white

        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = customNavBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = customNavBarAppearance
        navigationController?.navigationBar.compactAppearance = customNavBarAppearance

        tabBarController?.tabBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - 메소드

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NearbyCell.self, forCellReuseIdentifier: NearbyCell.reuseID)   // Cell 등록 (코드 베이스라서)
        tableView.rowHeight = NearbyCell.rowHeight
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // SearchController에 대한 설정들
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    // 서치바에 타이핑될 때 어떻게 할 건지 설정하는 함수 (유저의 검색에 반응하는 로직)
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text?.components(separatedBy: " ").joined(separator: ""), searchString.isEmpty == false {
            filteredItems = receivedData.filter { (item) -> Bool in
                item.name.components(separatedBy: " ").joined(separator: "").localizedCaseInsensitiveContains(searchString) || item.address.components(separatedBy: " ").joined(separator: "").localizedCaseInsensitiveContains(searchString)
            }
        } else {
            filteredItems = receivedData
        }

        tableView.reloadData()
    }

    func setupData(items: [Bookstore]) {
        receivedData = items
        filteredItems = items
    }
}

// MARK: - DataSource

extension NearbyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count == 0 ? tableView.setEmptyView(text: "현재 계신 곳 주변에 독립서점 정보가 없어요") : tableView.restore()

        return filteredItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NearbyCell.reuseID, for: indexPath) as? NearbyCell else { return UITableViewCell() }
        cell.bookstore = filteredItems[indexPath.row]

        self.imageRequestTask = Task {
            if let image = try? await ImageCache.shared.load(cell.bookstore!.images?.first) {
                cell.photoImageView.image = image
            }
            imageRequestTask = nil
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredItems.count == 0 ? nil : "총 \(filteredItems.count)개"
    }
}

// MARK: - Delegate

extension NearbyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let detailBookstoreViewController = DetailBookstoreViewController()
        detailBookstoreViewController.bookstore = filteredItems[indexPath.row]
        show(detailBookstoreViewController, sender: nil)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
