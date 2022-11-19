//
//  NearbyViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/19.
//

// TODO: 더미데이터 삭제 후 기존 모델 데이터와 연결 | UITable, UIbutton extension 따로 빼기 | extensinon 빼서 정리, PR
// 이외 ToDoList는 코드 속에 있으니 참조

import UIKit
   
final class NearbyViewController: UIViewController, UISearchResultsUpdating {
    
    // MARK: - 파이어베이스 Task

    private var imageRequestTask: Task<Void, Never>?
    
    deinit {
        imageRequestTask?.cancel()
    }
    
    // MARK: - 파이어베이스 매니저
    
    private let firestoreManager = FirestoreManager()
    
    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    // 검색된 프로퍼티 담을 배열 생성 (초기값은 전체가 담겨있는 배열) -> 이 기준으로 cell 나타낼 것이기 때문에 DataSource, Delegate에 이 프로퍼티 적용
    // TODO: 파이어베이스 데이터 연결
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
        if let searchString = searchController.searchBar.text?.components(separatedBy: " ").joined(separator: ""), searchString.isEmpty == false {
            filteredItems = receivedData.filter{ (item) -> Bool in
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
            if let image = try? await ImageCache.cache.load(url: cell.bookstore!.images?.first) {
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
