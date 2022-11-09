//
//  RegionViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//

// TODO: 지역 이름 분기 처리해서 표시 (regionHeaderView)

import UIKit

final class RegionViewController: UIViewController, UISearchResultsUpdating {

    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private var filteredItems = NewItems.bookstoreDummy
    
    private var regionItems: [Bookstore] = []
    
    private var regionName: String = ""

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
        
        // MARK: Navigation Bar Appearance
        // 서점 상세화면으로 넘어갔다 오면 상세화면의 네비게이션 바 설정이 적용되기에 재설정 해줬습니다.
        let customNavBarAppearance = UINavigationBarAppearance()
        customNavBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = customNavBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = customNavBarAppearance
        navigationController?.navigationBar.compactAppearance = customNavBarAppearance
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
            filteredItems = regionItems.filter{ (item) -> Bool in
                item.name.components(separatedBy: " ").joined(separator: "").localizedCaseInsensitiveContains(searchString) || item.address.components(separatedBy: " ").joined(separator: "").localizedCaseInsensitiveContains(searchString)
            }
        } else {
            filteredItems = regionItems
        }
        
        tableView.reloadData()
    }
    
    func setupData(regionName: String) {
        self.regionName = regionName
        filteredItems = NewItems().getBookstoreByRegion(regionName)
        regionItems = NewItems().getBookstoreByRegion(regionName)
    }
}

// MARK: - DataSource
//extension RegionViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        filteredItems.count == 0 ? tableView.setEmptyView(text: "찾으시는 서점이 없으신가요?") : tableView.restore()
//
//        return filteredItems.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: RegionCell.identifier, for: indexPath) as? RegionCell else { return UITableViewCell() }
//        cell.bookstore = filteredItems[indexPath.row]
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return filteredItems.count == 0 ? nil : "총 \(filteredItems.count)개"
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 65
//    }
//}
//
//// MARK: - Delegate
//extension RegionViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let detailBookstoreViewController = DetailBookstoreViewController()
//        detailBookstoreViewController.bookstore = filteredItems[indexPath.row]
//        show(detailBookstoreViewController, sender: nil)
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RegionHeaderView.identifier) as? RegionHeaderView else {
//            return UIView()
//        }
//
//        headerView.headerLabel.text = regionName
//
//        if filteredItems.count == 0 {
//            headerView.isHidden = true
//        } else {
//            headerView.isHidden = false
//        }
//
//        return headerView
//    }
//}
