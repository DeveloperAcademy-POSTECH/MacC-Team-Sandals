//
//  NearbyViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/19.
//

// TODO: 더미데이터 삭제 후 기존 모델 데이터와 연결 | UITable, UIbutton extension 따로 빼기 | extensinon 빼서 정리, PR
// 이외 ToDoList는 코드 속에 있으니 참조

import UIKit

class NearbyViewController: UIViewController, UISearchResultsUpdating {
    
    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    // 검색된 프로퍼티 담을 배열 생성 (초기값은 전체가 담겨있는 배열) -> 이 기준으로 cell 나타낼 것이기 때문에 DataSource, Delegate에 이 프로퍼티 적용
    private var filteredItems: [Dummy] = dummyList
    
    private let searchController = UISearchController()
    
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
        
        tableView.register(NearbyCell.self, forCellReuseIdentifier: NearbyCell.reuseID)   // Cell 등록 (코드 베이스라서)
        tableView.rowHeight = NearbyCell.rowHeight
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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

extension NearbyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count == 0 ? tableView.setEmptyView(text: "현재 계신 곳 주변에 독립서점 정보가 없어요") : tableView.restore()
        
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NearbyCell.reuseID, for: indexPath) as? NearbyCell else { return UITableViewCell() }
        cell.bookstore = filteredItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredItems.count == 0 ? nil : "총 \(filteredItems.count)개"
    }
}

// MARK: - Delegate

extension NearbyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: 서점 상세 페이지 연결
        /* let detailVC = DetailViewController()
        detailVC.bookstoreLbl.text = filteredItems[indexPath.row].name!
        navigationController?.pushViewController(detailVC, animated: true) */
        
        print("\(filteredItems[indexPath.row].name!) 상세 페이지 연결")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
