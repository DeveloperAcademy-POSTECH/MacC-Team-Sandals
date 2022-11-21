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
    
    private let firestoreManager = FirestoreManager()
    
    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var mainDummy: [Curation] = []
    
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

        createBarButtonItems()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update()
        updateUserData()
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
        let homeSearchViewController = HomeSearchViewController()
        show(homeSearchViewController, sender: nil)
    }
    
    @objc func writeButtonTapped() {
        if let user = user {
            // TODO: 큐레이션 작성 페이지 연결
            let waitAlert = UIAlertController(title: "작성 폼을 준비중입니다 🛠", message: "조금만 기다려주세요!", preferredStyle: .alert)
            let okay = UIAlertAction(title: "확인", style: .cancel)
            waitAlert.addAction(okay)
            present(waitAlert, animated: true, completion: nil)
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

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - 파이어베이스 update
    
    private func update() {
        curationsRequestTask?.cancel()
        curationsRequestTask = Task {
            if let curations = try? await firestoreManager.fetchCurations() {
                mainDummy = curations
            } else {
                mainDummy = []
            }
            self.tableView.reloadData()
            curationsRequestTask = nil
        }
    }
    
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

// MARK: - DataSource

extension CurationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return mainDummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurationListCell.identifier, for: indexPath) as? CurationListCell else { return UITableViewCell() }
        cell.curation = mainDummy[indexPath.row]
        
        self.imageRequestTask = Task {
            if let image = try? await ImageCache.shared.loadFromMemory(cell.curation?.descriptions[indexPath.item].image) {
                curationImage = image
                cell.photoImageView.image = curationImage
            }
            imageRequestTask = nil
        }
        
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
        vc.setupData(items: mainDummy, tag: sender.tag)
        
        show(vc, sender: nil)
    }
}
