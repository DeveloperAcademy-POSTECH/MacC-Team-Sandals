//
//  RegionViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//

// TODO: 헤더 패딩값 주기 (셀 시작점 내리는 방법), 지역 이름 분기 처리해서 표시 (regionHeaderView)

import UIKit

final class RegionViewController: UIViewController, UISearchResultsUpdating {

    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var filteredItems: [Dummy] = dummyList
    
    private let searchController = UISearchController()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let regionHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        setupTableView()
        
        dismissKeyboard()
    }

    // MARK: - 메소드
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = RegionCell.rowHeight
        tableView.register(RegionCell.self, forCellReuseIdentifier: RegionCell.identifier)   // Cell 등록 (코드 베이스라서)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        setupHeaderView()
    }
    
    private func setupHeaderView() {
        tableView.tableHeaderView = regionHeaderView
        regionHeaderView.addSubview(regionLabel)
        regionLabel.text = "포항"

        NSLayoutConstraint.activate([
            regionHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
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
        if let searchString = searchController.searchBar.text, searchString.isEmpty == false {
            filteredItems = dummyList.filter{ (item) -> Bool in
                item.name!.localizedCaseInsensitiveContains(searchString)
            }
        } else {
            filteredItems = dummyList
        }
        
        tableView.reloadData()
    }
}

// MARK: - DataSource

extension RegionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredItems.count == 0 {
            tableView.setEmptyView(text: "찾으시는 서점이 없으신가요?")
            regionHeaderView.isHidden = true
        } else {
            tableView.restore()
            regionHeaderView.isHidden = false
        }
        
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RegionCell.identifier, for: indexPath) as? RegionCell else { return UITableViewCell() }
        cell.bookstore = filteredItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredItems.count == 0 ? nil : "총 \(filteredItems.count)개"
    }
}

// MARK: - Delegate

extension RegionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: 서점 상세 페이지 연결
        /* let detailVC = DetailViewController()
        detailVC.bookstoreLbl.text = filteredItems[indexPath.row].name!
        navigationController?.pushViewController(detailVC, animated: true) */
        
        print("\(filteredItems[indexPath.row].name!) 상세 페이지 연결")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
