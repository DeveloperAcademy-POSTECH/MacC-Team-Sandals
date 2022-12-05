//
//  CurationListViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/11/08.
//

import UIKit

final class CurationListViewController: UIViewController {

    // MARK: - 파이어베이스 Task
    
    private var curationsRequestTask: Task<Void, Never>?
    private var imageRequestTask: Task<Void, Never>?
    private var userRequestTask: Task<Void, Never>?
    
    deinit {
        curationsRequestTask?.cancel()
        imageRequestTask?.cancel()
        userRequestTask?.cancel()
    }
    
    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let activityIndicatorView = ActivityIndicatorView()
    
    private var user: User?
    private var curations: [Curation] = []
    private var curationImage = UIImage()
    private var kinditorOfCuration: [String : String] = [:]
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createBarButtonItems()
        configureActivityIndicatorView()
        setupTableView()
        fetchCurations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        fetchUserData()
        fetchCurations()
        self.tableView.reloadData()
    }
    
    // MARK: - 메소드
    
    private func createBarButtonItems() {
        let logoImage = UIImage(named: "KindyLogo")?.resizeImage(size: CGSize(width: 80, height: 20)).withRenderingMode(.alwaysOriginal)
        
        let logoButton = UIBarButtonItem(
            image: logoImage,
            style: .plain,
            target: nil,
            action: nil)
        let writeButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(writeButtonDidTap))
        let searchButton = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(searchButtonDidTap))
        
        writeButton.tintColor = .black
        searchButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = logoButton
        navigationItem.rightBarButtonItems = [writeButton, searchButton]
    }
    
    @objc func searchButtonDidTap() {
        let searchViewController = SearchViewController()
        
        searchViewController.setupData(
            items: curations,
            itemType: .curationType,
            kinditorOfCuration: kinditorOfCuration)
        
        show(searchViewController, sender: nil)
    }
    
    @objc func writeButtonDidTap() {
        guard UserManager().isLoggedIn() else {
            presentLogInAlert()
            return
        }
        
        let curationCreateViewController = CurationCreateViewController(nil, nil, [])
        curationCreateViewController.newImageAndCuration = { newImages, newCuration in
            self.curationsRequestTask = Task {
                self.fetchCurations()
                self.curationsRequestTask = nil
            }
        }
        
        self.navigationController?.pushViewController(curationCreateViewController, animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = CurationListCell.rowHeight
        tableView.register(CurationListCell.self, forCellReuseIdentifier: CurationListCell.identifier)
        tableView.register(CurationListHeaderView.self, forHeaderFooterViewReuseIdentifier: CurationListHeaderView.identifier)
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refreshDidControl), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func refreshDidControl() {
        fetchCurations()
        refreshControl.endRefreshing()
    }
    
    private func configureActivityIndicatorView() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
    }
    
    // MARK: - 파이어베이스 update
    
    private func fetchCurations() {
        curationsRequestTask?.cancel()
        curationsRequestTask = Task {
            activityIndicatorView.startAnimating()
            
            if let curations = try? await CurationRequest().fetch() {
                self.curations = curations
                self.curations.sort(by: { first, second in
                    first.createdAt ?? Date() > second.createdAt ?? Date()
                })
            } else { self.curations = [] }
            
            for curation in curations {
                if let nickname = try? await UserManager().fetch(with: curation.userID).nickName {
                    self.kinditorOfCuration[curation.userID] = nickname
                }
            }
            activityIndicatorView.stopAnimating()
            
            self.tableView.reloadData()
            curationsRequestTask = nil
        }
    }
    
    private func fetchUserData() {
        guard UserManager().isLoggedIn() else { return }
        
        userRequestTask?.cancel()
        userRequestTask = Task {
            guard let user = try? await UserManager().fetchCurrentUser() else {
                userRequestTask = nil
                return
            }
            self.user = user
            userRequestTask = nil
        }
    }
}

// MARK: - DataSource

extension CurationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return curations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurationListCell.identifier, for: indexPath) as? CurationListCell else { return UITableViewCell() }
        cell.curation = curations[indexPath.row]
        
        self.imageRequestTask = Task {
            if let image = try? await ImageCache.shared.loadFromMemory(cell.curation?.mainImage) {
                curationImage = image
                cell.photoImageView.image = curationImage
            }
            imageRequestTask = nil
        }
        
        cell.kinditor = kinditorOfCuration[cell.curation?.userID ?? "킨디"] ?? "킨디터"

        guard UserManager().isLoggedIn() else {
            cell.curationIsLiked = false
            return cell
        }
        
        let userID = UserManager().getID()
        cell.curationIsLiked = (cell.curation?.likes ?? []).contains(userID)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

// MARK: - Delegate

extension CurationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curationVC = PagingCurationViewController(curation: curations[indexPath.row])
        curationVC.modalPresentationStyle = .fullScreen
        curationVC.modalTransitionStyle = .crossDissolve
        
        present(curationVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CurationListHeaderView.identifier) as? CurationListHeaderView else { return UIView() }

        headerView.isHidden = curations.isEmpty
        
        let bookstoreButton = headerView.bookstoreButton
        let bookButton = headerView.bookButton
        
        bookstoreButton.tag = 1
        bookButton.tag = 2
        
        [bookstoreButton, bookButton].forEach{ $0.addTarget(self, action: #selector(categoryButtonDidTap), for: .touchUpInside) }

        return headerView
    }
    
    @objc func categoryButtonDidTap(_ sender: UIButton) {
        let featuredCurationList = FeaturedCurationListViewController()
        featuredCurationList.setData(items: curations, tag: sender.tag, kinditorOfCuration: kinditorOfCuration)
        
        show(featuredCurationList, sender: nil)
    }
}
