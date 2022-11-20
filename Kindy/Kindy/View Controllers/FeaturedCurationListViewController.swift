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
    
    deinit {
        userRequestTask?.cancel()
        imageRequestTask?.cancel()
    }
    
    private let firestoreManager = FirestoreManager()
    
    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var category: String = ""
    private var curationList: [Curation]? = []
    
    private var curationImage = UIImage()
    
    private var user: User? {
        didSet {
            guard let user = user else { return }
            
            // user가 좋아요한 큐레이션 게시글 목록 필요함
        }
    }
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = category
        createBarButtonItems()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        updateUserData()
    }
    
    // MARK: - 메소드
    
    private func createBarButtonItems() {
        let writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonTapped))
        writeButton.tintColor = .black
        navigationItem.rightBarButtonItem = writeButton
    }
    
    @objc func writeButtonTapped() {
        if let user = user {
            // TODO: 큐레이션 작성 페이지 연결
            
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
    
    func setupData(items: [Curation]?, tag: Int) {
        curationList = items
        category = tag == 1 ? "서점" : "책"
    }
    
    // MARK: - 파이어베이스 update
    
    private func updateUserData() {
        userRequestTask?.cancel()
        userRequestTask = Task {
            if firestoreManager.isLoggedIn() {
                if let user = try? await firestoreManager.fetchCurrentUser() {
                    self.user = user
                }
            }
            userRequestTask = nil
        }
    }
}

// MARK: - 데이터소스

extension FeaturedCurationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return curationList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurationListCell.identifier, for: indexPath) as? CurationListCell else { return UITableViewCell() }
        cell.curation = curationList?[indexPath.row]
        
        self.imageRequestTask = Task {
            if let image = try? await firestoreManager.fetchImage(with: cell.curation?.mainImage) {
                curationImage = image
                cell.photoImageView.image = curationImage
            }
            imageRequestTask = nil
        }
        
        return cell
    }
}

// MARK: - 델리게이트

extension FeaturedCurationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curationVC = PagingCurationViewController(curation: (curationList![indexPath.row]))
        curationVC.modalPresentationStyle = .overFullScreen
        curationVC.modalTransitionStyle = .crossDissolve
        
        present(curationVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
