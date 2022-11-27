//
//  WritingListViewController.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/26.
//

import UIKit

// 어느 셀을 누르고 들어왔는지 판단하기 위한 enum
enum PreviousSelectedCell {
    case myCuration
//    case mySmallTalk
    case likeList
    case commentList
}

final class WritingListViewController: UIViewController {

    // MARK: Properties
    private var curationsRequestTask: Task<Void, Never>?
    private var imageRequestTask: Task<Void, Never>?
    private var userRequestTask: Task<Void, Never>?
    
    deinit {
        curationsRequestTask?.cancel()
        imageRequestTask?.cancel()
        userRequestTask?.cancel()
    }
    
    var previousSelectedCell: PreviousSelectedCell = .myCuration

    private let writingTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let noWritingLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noWritingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var writings: [Curation] = []
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        
    }
    
    // MARK: Helpers
    private func setupTableView() {
        writingTableView.dataSource = self
        writingTableView.delegate = self
        writingTableView.rowHeight = CurationListCell.rowHeight
        writingTableView.register(CurationListCell.self, forCellReuseIdentifier: CurationListCell.identifier)
    }
    
    private func setupUI() {
        view.addSubview(writingTableView)
        
        NSLayoutConstraint.activate([
            writingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            writingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            writingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            writingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.black
        
        switch previousSelectedCell {
        case .myCuration:
            navigationItem.title = "내 글 목록"
//        case .smallTalk:
//            navigationItem.title = ""
        case .likeList:
            navigationItem.title = "좋아요 한 글"
        case .commentList:
            navigationItem.title = "댓글 단 글"
        }
    }
    
}

// MARK: Extensions
// MARK: UITableViewDataSource
extension WritingListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return writings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurationListCell.identifier, for: indexPath) as? CurationListCell else { return UITableViewCell() }
        cell.curation = writings[indexPath.row]
        
        imageRequestTask = Task {
            let descriptions = writings[indexPath.row].descriptions
            if let image = try? await ImageCache.shared.load(descriptions[indexPath.row].image) {
                cell.photoImageView.image = image
            } else {
                cell.photoImageView.image = UIImage()
            }
            imageRequestTask = nil
        }
        return cell
    }

}

// MARK: UITableViewDelegate
extension WritingListViewController: UITableViewDelegate {
    
}
