//
//  CurationListViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/11/08.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

final class CurationListViewController: UIViewController {

    // MARK: - 파이어베이스 Task
    
    var curationsRequestTask: Task<Void, Never>?
    var imageRequestTask: Task<Void, Never>?
    
    deinit {
        curationsRequestTask?.cancel()
        imageRequestTask?.cancel()
    }
    
    let firestoreManager = FirestoreManager()
    
    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var mainDummy: [Curation] = []
    
    private var model = Model()
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createBarButtonItems()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update()
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
    
    // MARK: - 파이어베이스 update
    
    func update() {
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
    
}

// MARK: - DataSource

extension CurationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return mainDummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurationListCell.identifier, for: indexPath) as? CurationListCell else { return UITableViewCell() }
        cell.curation = mainDummy[indexPath.row]
        
//        self.imageRequestTask = Task {
//            if let image = try? await firestoreManager.fetchImage(with: mainDummy[indexPath.row].descriptions[indexPath.item].image) {
//                cell.imageView?.image = image
//            }
//            imageRequestTask = nil
//        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
}

// MARK: - Delegate

extension CurationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let detailBookstoreViewController = DetailBookstoreViewController()
//        detailBookstoreViewController.bookstore = mainDummy[indexPath.row]
//        show(detailBookstoreViewController, sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CurationListHeaderView.identifier) as? CurationListHeaderView else { return UIView() }

//        headerView.headerLabel.text = "카테고리"
//        let btn1 = CurationCategoryButton(categoryName: "최신")
//        let btn2 = CurationCategoryButton(categoryName: "서점")
//        let btn3 = CurationCategoryButton(categoryName: "책")
//
//        [btn1, btn2, btn3].forEach{ headerView.headerStackView.addSubview($0) }
        headerView.btn1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.btn1.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 30)
        ])

        if mainDummy.count == 0 {
            headerView.isHidden = true
        } else {
            headerView.isHidden = false
        }

        return headerView
    }
}
