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
    
    private var mainDummy: [Curation] = []
    
    private var curationImage = UIImage()
    
    private var user: User?
    
    private var kinditorOfCuration: [String : String] = [:]
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createBarButtonItems()
        setupTableView()
        fetchCuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserData()
        self.tableView.reloadData()
    }
    
    // MARK: - 메소드
    
    private func createBarButtonItems() {
        let scaledImage = UIImage(named: "KindyLogo")?.resizeImage(size: CGSize(width: 80, height: 20)).withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: scaledImage, style: .plain, target: nil, action: nil)
        
        let writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonTapped))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        
        writeButton.tintColor = .black
        searchButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [writeButton, searchButton]
    }
    
    @objc func searchButtonTapped() {
        let searchViewController = SearchViewController()
        searchViewController.setupData(items: mainDummy, itemType: .curationType, kinditorOfCuration: kinditorOfCuration)
        show(searchViewController, sender: nil)
    }
    
    @objc func writeButtonTapped() {
        if UserManager().isLoggedIn() {
            self.navigationController?.pushViewController(CurationCreateViewController(nil, nil, []), animated: true)
        } else {
            let alertForSignIn = UIAlertController(title: "로그인이 필요한 기능입니다", message: "로그인하시겠습니까?", preferredStyle: .alert)
            let action = UIAlertAction(title: "로그인", style: .default, handler: { _ in
                let signInViewController = SignInViewController()
                self.navigationController?.pushViewController(signInViewController, animated: true)
            })
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alertForSignIn.addAction(cancel)
            alertForSignIn.addAction(action)
            present(alertForSignIn, animated: true, completion: nil)
        }
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
        tableView.refreshControl?.addTarget(self, action: #selector(refreshControlled), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func refreshControlled() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.fetchCuration()
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - 파이어베이스 update
    
    private func fetchCuration() {
        curationsRequestTask?.cancel()
        curationsRequestTask = Task {
            if let curations = try? await CurationRequest().fetch() {
                mainDummy = curations
            } else {
                mainDummy = []
            }
            
            for curation in mainDummy {
                if let nickname = try? await UserManager().fetch(with: curation.userID).nickName {
                    self.kinditorOfCuration[curation.userID] = nickname
                }
            }
            
            self.tableView.reloadData()
            curationsRequestTask = nil
        }
    }
    
    private func fetchUserData() {
        if UserManager().isLoggedIn() {
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
}

// MARK: - DataSource

extension CurationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return mainDummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurationListCell.identifier, for: indexPath) as? CurationListCell else { return UITableViewCell() }
        cell.curation = mainDummy[indexPath.row]
        
        self.imageRequestTask = Task {
            if let image = try? await ImageCache.shared.loadFromMemory(cell.curation?.mainImage, size: ImageSize.big) {
                curationImage = image
                cell.photoImageView.image = curationImage
            }
            imageRequestTask = nil
        }
        
        cell.kinditor = kinditorOfCuration[cell.curation?.userID ?? "킨디"]

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
        let curationVC = PagingCurationViewController(curation: mainDummy[indexPath.row])
        curationVC.modalPresentationStyle = .overFullScreen
        curationVC.modalTransitionStyle = .crossDissolve
        
        present(curationVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CurationListHeaderView.identifier) as? CurationListHeaderView else { return UIView() }

        headerView.isHidden = mainDummy.isEmpty
        
        let bookstoreBtn = headerView.bookstoreButton
        let bookBtn = headerView.bookButton
        
        bookstoreBtn.tag = 1
        bookBtn.tag = 2
        
        [bookstoreBtn, bookBtn].forEach{ $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside) }

        return headerView
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let vc = FeaturedCurationListViewController()
        vc.setupData(items: mainDummy, tag: sender.tag, kinditorOfCuration: kinditorOfCuration)
        
        show(vc, sender: nil)
    }
}
