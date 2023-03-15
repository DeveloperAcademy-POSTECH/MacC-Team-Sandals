//
//  RegionViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//

import UIKit

final class RegionViewController: UIViewController, UISearchResultsUpdating {

    // MARK: - 파이어베이스 Task

    private var imageRequestTask: Task<Void, Never>?

    deinit {
        imageRequestTask?.cancel()
    }

    // MARK: - 프로퍼티

    private var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private var regionName: String = ""
    private var receivedData: [Bookstore] = []
    private var filteredItems: [Bookstore] = []

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
        self.navigationItem.title = "지역별 서점"

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
        tableView.rowHeight = RegionCell.rowHeight
        tableView.register(RegionCell.self, forCellReuseIdentifier: RegionCell.identifier)   // Cell 등록 (코드 베이스라서)
        tableView.register(RegionHeaderView.self, forHeaderFooterViewReuseIdentifier: RegionHeaderView.identifier)

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

    func setupData(regionName: String, items: [Bookstore]) {
        self.regionName = regionName
        self.receivedData = getBookstoreByRegion(items: items, region: regionName)
        self.filteredItems = getBookstoreByRegion(items: items, region: regionName)
    }

    private func getBookstoreByRegion(items: [Bookstore], region: String) -> [Bookstore] {
        switch region {
        case "전체":
            return items
        case "서울":
            return items.filter { $0.address.contains("서울") }
        case "강원":
            return items.filter { $0.address.contains("강원") }
        case "경기/인천":
            return items.filter { $0.address.contains("경기") || $0.address.contains("인천") }
        case "충청/대전":
            return items.filter { $0.address.contains("충청") || $0.address.contains("대전") || $0.address.contains("세종") || $0.address.contains("충북") || $0.address.contains("충남") }
        case "경북/대구":
            return items.filter { $0.address.contains("경상북도") || $0.address.contains("대구") || $0.address.contains("경북") }
        case "전라/광주":
            return items.filter { $0.address.contains("전라남도") || $0.address.contains("전남") || $0.address.contains("전라북도") || $0.address.contains("전북") || $0.address.contains("광주광역시") }
        case "경남/울산/부산":
            return items.filter { $0.address.contains("경상남도") || $0.address.contains("경남") || $0.address.contains("울산") || $0.address.contains("부산") }
        case "제주":
            return items.filter { $0.address.contains("제주") }
        default:
            return []
        }
    }
}

// MARK: - 데이터 소스
// swiftlint:disable empty_count
extension RegionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count == 0 ? tableView.setEmptyView(text: "찾으시는 서점이 없으신가요?") : tableView.restore()

        return filteredItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RegionCell.identifier, for: indexPath) as? RegionCell else { return UITableViewCell() }
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

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
}

// MARK: - 델리게이트

extension RegionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailBookstoreViewController = DetailBookstoreViewController()
        detailBookstoreViewController.bookstore = filteredItems[indexPath.row]
        show(detailBookstoreViewController, sender: nil)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RegionHeaderView.identifier) as? RegionHeaderView else {
            return UIView()
        }

        headerView.headerLabel.text = regionName

        if filteredItems.count == 0 {
            headerView.isHidden = true
        } else {
            headerView.isHidden = false
        }

        return headerView
    }
}
