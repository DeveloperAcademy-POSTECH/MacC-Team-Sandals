//
//  FeaturedCurationListViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/11/20.
//

import UIKit

final class FeaturedCurationListViewController: UIViewController {

    // MARK: - 파이어베이스 Task

    private var userRequestTask: Task<Void, Never>?
    private var imageRequestTask: Task<Void, Never>?
    private var curationsRequestTask: Task<Void, Never>?
    
    deinit {
        userRequestTask?.cancel()
        imageRequestTask?.cancel()
        curationsRequestTask?.cancel()
    }
    
    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var user: User?
    private var category: String = "book"
    private var curations: [Curation]?
    private var curationImage = UIImage()
    private var kinditorsByCuration: [String : String] = [:]
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = category == "bookstore" ? "서점" : "도서"
        createBarButtonItems()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = ""         // back 버튼 없애기
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = category == "bookstore" ? "서점" : "도서"    // 네비게이션 타이틀도 없어져서 다시 설정해주기
        
        fetchUserData()
        fetchCurations(of: category)
    }
    
    // MARK: - 메소드
    
    private func createBarButtonItems() {
        let writeButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(writeButtonDidTap))
        
        writeButton.tintColor = .black
        navigationItem.rightBarButtonItem = writeButton
    }
    
    @objc func writeButtonDidTap() {
        guard UserManager().isLoggedIn() else {
            presentLogInAlert()
            return
        }
        
        let curationCreateViewController = CurationCreateViewController(nil, nil, [])
        curationCreateViewController.newImageAndCuration = { newImages, newCuration in
            self.curationsRequestTask = Task {
                self.fetchCurations(of: self.category)
                self.curationsRequestTask = nil
            }
        }
        
        self.navigationController?.pushViewController(curationCreateViewController, animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = CurationListCell.rowHeight
        tableView.register(CurationListCell.self, forCellReuseIdentifier: CurationListCell.identifier)
        tableView.register(CurationListHeaderView.self, forHeaderFooterViewReuseIdentifier: CurationListHeaderView.identifier)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setData(items: [Curation]?, tag: Int, kinditorOfCuration: [String : String]) {
        self.category = tag == 1 ? "bookstore" : "book"
        self.curations = items?.filter{ $0.category == self.category }
        self.kinditorsByCuration = kinditorOfCuration
    }
    
    // MARK: - 파이어베이스 fetch
    
    private func fetchCurations(of category: String) {
        curationsRequestTask?.cancel()
        curationsRequestTask = Task {
            guard let curations = try? await CurationRequest().fetch() else {
                self.curations = []
                return
            }
            
            self.curations = curations.filter{ $0.category == category }
            self.curations?.sort(by: { first, second in
                first.createdAt ?? Date() > second.createdAt ?? Date()
            })
            
            for curation in curations {
                let userID = curation.userID
                if let nickname = try? await UserManager().fetch(with: userID).nickName {
                    self.kinditorsByCuration[userID] = nickname
                }
            }
            
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

// MARK: - 데이터소스

extension FeaturedCurationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (curations ?? []).isEmpty {
            tableView.setCurationEmptyView(text: "아직 작성된 큐레이션이 없어요 🥲")
        }
        
        return curations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurationListCell.identifier, for: indexPath) as? CurationListCell else { return UITableViewCell() }
        cell.curation = curations?[indexPath.row]
        
        self.imageRequestTask = Task {
            if let image = try? await ImageCache.shared.loadFromMemory(cell.curation?.mainImage) {
                curationImage = image
                cell.photoImageView.image = curationImage
            }
            imageRequestTask = nil
        }
        
        cell.kinditor = kinditorsByCuration[cell.curation?.userID ?? ""]
        
        guard UserManager().isLoggedIn() else {
            cell.curationIsLiked = false
            
            return cell
        }
        
        let userID = UserManager().getID()
        cell.curationIsLiked = (cell.curation?.likes ?? []).contains(userID)
        
        return cell
    }
}

// MARK: - 델리게이트

extension FeaturedCurationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curationViewController = PagingCurationViewController(curation: (curations![indexPath.row]))
        curationViewController.modalPresentationStyle = .fullScreen
        curationViewController.modalTransitionStyle = .crossDissolve
        
        present(curationViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
