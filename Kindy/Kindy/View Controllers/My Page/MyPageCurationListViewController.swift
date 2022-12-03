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
    case likeList
    case commentList
}

final class MyPageCurationListViewController: UIViewController {
    
    // MARK: Properties
    private var curationsRequestTask: Task<Void, Never>?
    private var imageRequestTask: Task<Void, Never>?
    private var userRequestTask: Task<Void, Never>?
    
    var previousSelectedCell: PreviousSelectedCell = .myCuration
    
    private let writingTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset.left = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // 글이 없을때 보여줄 뷰
    private let noWritingView = NoWritingView()
    
    private var curations: [Curation] = []
    private var kinditorOfCuration: [String : String] = [:]
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        tabBarController?.tabBar.isHidden = true
        fetchCurations()
    }
    
    deinit {
        curationsRequestTask?.cancel()
        imageRequestTask?.cancel()
        userRequestTask?.cancel()
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
    
    private func fetchCurations() {
        let userID = UserManager().getID()
        curationsRequestTask?.cancel()
        
        curationsRequestTask = Task {
            switch previousSelectedCell {
            case .myCuration:
                if let curations = try? await CurationRequest().fetchMyCuration(userID: userID) {
                    processAfterCurationRequest(curations)
                } else {
                    setupNoWritingView()
                }
                
            case .likeList:
                if let curations = try? await CurationRequest().fetchLikeCurations(userID: userID) {
                    processAfterCurationRequest(curations)
                } else {
                    setupNoWritingView()
                }
                
            case .commentList:
                if let curations = try? await CurationRequest().fetchCommentedCurations(userID: userID) {
                    processAfterCurationRequest(curations)
                } else {
                    setupNoWritingView()
                }
            }
            curationsRequestTask = nil
        }
    }
    
    private func processAfterCurationRequest(_ curations: [Curation]) {
        self.curations = curations
        
        guard !self.curations.isEmpty else {
            setupNoWritingView()
            curationsRequestTask = nil
            return
        }
        
        userRequestTask?.cancel()
        userRequestTask = Task {
            for curation in self.curations {
                if let nickname = try? await UserManager().fetch(with: curation.userID).nickName {
                    self.kinditorOfCuration[curation.userID] = nickname
                }
            }
            userRequestTask = nil
            writingTableView.reloadData()
        }
    }
    
    private func setupNoWritingView() {
        view.addSubview(noWritingView)
        noWritingView.translatesAutoresizingMaskIntoConstraints = false
        
        switch previousSelectedCell {
        case .myCuration:
            noWritingView.noWritingLabel.text = "내 글이 메인에 소개될 기회를 잡아보세요!"
            noWritingView.noWritingButton.setTitle("큐레이션 작성하기", for: .normal)
            noWritingView.noWritingButton.addTarget(self, action: #selector(writeCurationButtonTapped), for: .touchUpInside)
            
        case .likeList:
            noWritingView.noWritingLabel.text = "아직 좋아요 한 글이 없어요"
            noWritingView.noWritingButton.setTitle("큐레이션 보러가기", for: .normal)
            noWritingView.noWritingButton.addTarget(self, action: #selector(readCurationsButtonTapped), for: .touchUpInside)
            
        case .commentList:
            noWritingView.noWritingLabel.text = "아직 댓글 단 글이 없어요"
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
extension MyPageCurationListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurationListCell.identifier, for: indexPath) as? CurationListCell else { return UITableViewCell() }
        
        let currentCuration = curations[indexPath.row]
        cell.curation = currentCuration
        
        imageRequestTask = Task {
            if let image = try? await ImageCache.shared.load(currentCuration.mainImage) {
                cell.photoImageView.image = image
            } else {
                cell.photoImageView.image = UIImage()
            }
            imageRequestTask = nil
        }
        
        cell.kinditor = kinditorOfCuration[cell.curation?.userID ?? "킨디"]
        
        let userID = UserManager().getID()
        cell.curationIsLiked = (cell.curation?.likes ?? []).contains(userID)
        
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension MyPageCurationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curationVC = PagingCurationViewController(curation: curations[indexPath.row])
        curationVC.modalPresentationStyle = .overFullScreen
        curationVC.modalTransitionStyle = .crossDissolve
        present(curationVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
