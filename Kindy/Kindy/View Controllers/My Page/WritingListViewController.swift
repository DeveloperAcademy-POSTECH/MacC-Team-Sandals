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
    
    // 글이 없을때 보여줄 뷰
    private let noWritingView = NoWritingView()
    
    private var writings: [Curation] = []
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        fetchCurations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: Helpers
    private func setupTableView() {
        writingTableView.dataSource = self
        writingTableView.delegate = self
        writingTableView.rowHeight = CurationListCell.rowHeight
        writingTableView.register(CurationListCell.self, forCellReuseIdentifier: CurationListCell.identifier)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        guard !writings.isEmpty else {
            setupNoWritingView()
            return
        }
        
        view.addSubview(writingTableView)
        NSLayoutConstraint.activate([
            writingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            writingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            writingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            writingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNoWritingView() {
        view.addSubview(noWritingView)
        noWritingView.translatesAutoresizingMaskIntoConstraints = false
        
        switch previousSelectedCell {
        case .myCuration:
            noWritingView.noWritingLable.text = "내 글이 메인에 소개될 기회를 잡아보세요!"
            noWritingView.noWritingButton.setTitle("큐레이션 작성하기", for: .normal)
            noWritingView.noWritingButton.addTarget(self, action: #selector(writeCurationButtonTapped), for: .touchUpInside)
            
//        case .smallTalk:
            
        case .likeList:
            noWritingView.noWritingLable.text = "아직 좋아요 한 글이 없어요"
            noWritingView.noWritingButton.setTitle("큐레이션 보러가기", for: .normal)
            noWritingView.noWritingButton.addTarget(self, action: #selector(readCurationsButtonTapped), for: .touchUpInside)
            
        case .commentList:
            noWritingView.noWritingLable.text = "아직 댓글 단 글이 없어요"
            noWritingView.noWritingButton.setTitle("큐레이션 보러가기", for: .normal)
            noWritingView.noWritingButton.addTarget(self, action: #selector(readCurationsButtonTapped), for: .touchUpInside)
        }
        
        noWritingView.noWritingButton.setUnderline()
        NSLayoutConstraint.activate([
            noWritingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noWritingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noWritingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding16),
            noWritingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding16),
            noWritingView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    // TODO: 조건에 맞는 큐레이션 들고오기
    private func fetchCurations() {
//        curationsRequestTask?.cancel()
//
////        switch previousSelectedCell {
////        case .myCuration:
////            <#code#>
////        case .likeList:
////            <#code#>
////        case .commentList:
////            <#code#>
////        }
//        curationsRequestTask = Task {
//            if let curations = try? await CurationRequest().fetch() {
//
//            } else {
//                writings = []
//            }
//            curationsRequestTask = nil
//        }
        writingTableView.reloadData()
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
    
    // MARK: Actions
    @objc func writeCurationButtonTapped() {
        print("DEBUG: TO WRITE")
    }
    
    @objc func readCurationsButtonTapped() {
        // 큐레이션 리스트 탭바 페이지로 이동
        tabBarController?.selectedIndex = 1
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
            if let image = try? await ImageCache.shared.load(descriptions[indexPath.row].image, size: ImageSize.big) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curationVC = PagingCurationViewController(curation: writings[indexPath.row])
        curationVC.modalPresentationStyle = .overFullScreen
        curationVC.modalTransitionStyle = .crossDissolve
        present(curationVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
