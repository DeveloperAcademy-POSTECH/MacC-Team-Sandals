//
//  HomeSearchViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/23.
//

import UIKit
   
final class SearchViewController: UIViewController, UISearchResultsUpdating {

    // MARK: - 파이어베이스 Task

    private var imageRequestTask: Task<Void, Never>?
    private var userRequestTask: Task<Void, Never>?

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
    
    private var searchObjectType: SearchObjectType?
    
    private var receivedData: [Any] = []
    
    private var filteredItems: [Any] = []
    
    private var kinditorOfCuration: [String : String] = [:]
    
    private let searchController = UISearchController()
    
    private var searchText: String? = ""
    
    enum SearchObjectType {
        case bookstoreType, curationType
    }
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        setupCustomCancelButton(of: searchController)
        searchController.searchBar.placeholder = searchObjectType == .bookstoreType ? "서점 이름, 주소 검색" : "게시글 제목, 내용 검색"
        setupTableView()
        dismissKeyboard()
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
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async {  // must call from main thread
            self.searchController.searchBar.becomeFirstResponder()
        }
        // 코드 출처 : https://stackoverflow.com/questions/31274058/make-uisearchcontroller-search-bar-automatically-active/
        // 개념 이해 : https://stackoverflow.com/questions/27951965/cannot-set-searchbar-as-firstresponder
    }
    
    // MARK: - 메소드
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        self.navigationItem.hidesBackButton = true
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupTableView() {
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        
        switch searchObjectType {
        case .bookstoreType:
            tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
            tableView.rowHeight = SearchCell.rowHeight
            
        case .curationType:
            tableView.register(CurationListCell.self, forCellReuseIdentifier: CurationListCell.identifier)
            tableView.rowHeight = CurationListCell.rowHeight
            
        default: return
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text?.components(separatedBy: " ").joined(separator: ""), searchString.isEmpty == false {
            searchText = searchString
            
            switch searchObjectType {
            case .bookstoreType:
                filteredItems = receivedData.filter{ (item) -> Bool in
                    (item as? Bookstore)!.name.components(separatedBy: " ").joined(separator: "").localizedCaseInsensitiveContains(searchString) || (item as? Bookstore)!.address.components(separatedBy: " ").joined(separator: "").localizedCaseInsensitiveContains(searchString)
                }
                
            case .curationType:
                filteredItems = receivedData.filter{ (item) -> Bool in
                    (item as? Curation)!.title.components(separatedBy: " ").joined(separator: "").localizedCaseInsensitiveContains(searchString) || (item as? Curation)!.subTitle!.components(separatedBy: " ").joined(separator: "").localizedCaseInsensitiveContains(searchString) || (item as? Curation)!.headText.components(separatedBy: " ").joined(separator: "").localizedCaseInsensitiveContains(searchString)
                }
                
            default: filteredItems = []
            }
            
        } else {
            filteredItems = []
            searchText = ""
        }
        
        tableView.reloadData()
    }
    
    func setupData(items: [Any], itemType: SearchObjectType, kinditorOfCuration: [String : String]) {
        self.receivedData = items
        self.searchObjectType = itemType
        self.kinditorOfCuration = kinditorOfCuration
    }
}

// MARK: - 데이터 소스

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchObjectType {
        case .bookstoreType: filteredItems.isEmpty && searchText != "" ? tableView.setEmptyView(text: "찾으시는 서점이 없으신가요?") : tableView.restore()
        case .curationType: filteredItems.isEmpty && searchText != "" ? tableView.setCurationEmptyView(text: "아직 작성된 큐레이션이 없어요 🥲") : tableView.restore()
        default: print("default")
        }
        
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchObjectType {
        case .bookstoreType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { return UITableViewCell() }
            
            cell.bookstore = filteredItems[indexPath.row] as? Bookstore
            
            self.imageRequestTask = Task {
                if let image = try? await ImageCache.shared.load(cell.bookstore!.images?.first) {
                    cell.photoImageView.image = image
                }
                imageRequestTask = nil
            }
            
            return cell
            
        case .curationType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurationListCell.identifier, for: indexPath) as? CurationListCell else { return UITableViewCell() }
            
            cell.curation = filteredItems[indexPath.row] as? Curation
            
            self.imageRequestTask = Task {
                if let image = try? await ImageCache.shared.loadFromMemory(cell.curation?.mainImage) {
                    cell.photoImageView.image = image
                }
                imageRequestTask = nil
            }
            
            cell.kinditor = kinditorOfCuration[cell.curation?.userID ?? ""]
            
            guard UserManager().isLoggedIn() else { cell.curationIsLiked = false; return cell }
            let userID = UserManager().getID()
            cell.curationIsLiked = (cell.curation?.likes ?? []).contains(userID)
            
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredItems.count == 0 ? nil : "총 \(filteredItems.count)개"
    }
}

// MARK: - 델리게이트

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchObjectType {
        case .bookstoreType:
            let detailBookstoreVC = DetailBookstoreViewController()
            detailBookstoreVC.bookstore = filteredItems[indexPath.row] as? Bookstore
            navigationController?.pushViewController(detailBookstoreVC, animated: true)
            
        case .curationType:
            let curationVC = PagingCurationViewController(curation: (filteredItems[indexPath.row] as? Curation)!)
            curationVC.modalPresentationStyle = .overFullScreen
            curationVC.modalTransitionStyle = .crossDissolve
            
            present(curationVC, animated: true)
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        default: return
        }
    }
}

// MARK: - 서치바 취소 버튼 delegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
