//
//  HomeSearchViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/23.
//

import UIKit

final class HomeSearchViewController: UIViewController, UISearchResultsUpdating {

    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var filteredItems: [Bookstore] = []
    
    private let searchController = UISearchController()
    
    private var searchText: String? = ""
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        setupTableView()
        
        dismissKeyboard()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async {  // must call from main thread
            self.searchController.searchBar.becomeFirstResponder()
        }
        // 코드 출처 : https://stackoverflow.com/questions/31274058/make-uisearchcontroller-search-bar-automatically-active/
        // 개념 이해 : https://stackoverflow.com/questions/27951965/cannot-set-searchbar-as-firstresponder
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: Navigation Bar Appearance
        // 서점 상세화면으로 넘어갔다 오면 상세화면의 네비게이션 바 설정이 적용되기에 재설정 해줬습니다.
        let customNavBarAppearance = UINavigationBarAppearance()
        customNavBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.standardAppearance = customNavBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = customNavBarAppearance
        navigationController?.navigationBar.compactAppearance = customNavBarAppearance
    }
    
    // MARK: - 메소드
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        self.navigationItem.hidesBackButton = true
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        customCancelButton()
    }
    
    private func customCancelButton() {
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = UIColor(red: 0.173, green: 0.459, blue: 0.355, alpha: 1)
        searchController.searchBar.placeholder = "서점 이름, 주소 검색"
        searchController.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeSearchCell.self, forCellReuseIdentifier: HomeSearchCell.identifier)
        tableView.rowHeight = HomeSearchCell.rowHeight
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text, searchString.isEmpty == false {
            searchText = searchString
            filteredItems = NewItems.bookstoreDummy.filter{ (item) -> Bool in
                item.name.localizedCaseInsensitiveContains(searchText!)
            }
        } else {
            filteredItems = []
            searchText = ""
        }
        
        tableView.reloadData()
    }
}

// MARK: - data source

extension HomeSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.isEmpty && searchText != "" ? tableView.setEmptyView(text: "찾으시는 서점이 없으신가요?") : tableView.restore()
        
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeSearchCell.identifier, for: indexPath) as? HomeSearchCell else { return UITableViewCell() }
        
        cell.bookstore = filteredItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredItems.count == 0 ? nil : "총 \(filteredItems.count)개"
    }
}

// MARK: - delegate

extension HomeSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let detailBookstoreViewController = DetailBookstoreViewController()
        detailBookstoreViewController.bookstore = filteredItems[indexPath.row]
        navigationController?.pushViewController(detailBookstoreViewController, animated: true)
        
    }
}

// MARK: - 서치바 취소 버튼 delegate

extension HomeSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
