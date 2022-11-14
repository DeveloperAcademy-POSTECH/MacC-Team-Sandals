//
//  DetailBookstoreViewController.swift
//  Kindy
//
//  Created by WooriJoon on 2022/10/21.
//

import UIKit
import MapKit


final class DetailBookstoreViewController: UIViewController {
    
    private var defaultScrollYOffset: CGFloat = 0
    
    private let firestoreManager = FirestoreManager()
    private var userRequestTask: Task<Void, Never>?
    private var bookmarkUpdateTask: Task<Void, Never>?
    private var imageRequestTask: Task<Void, Never>?
    
    // 초기 User 정보를 받아와지면 bookmark된 서점인지 확인하여 북마크 버튼 이미지 변경
    private var user: User? {
        didSet {
            guard let user = user else { return }
            if user.bookmarkedBookstores.contains(bookstore?.id ?? "nil") {
                isBookmarked = true
                bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                isBookmarked = false
                bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
    }
    
    var bookstore: Bookstore?
    
    let detailBookstoreView = DetailBookstoreView()
    
    private lazy var mainScrollView = detailBookstoreView.mainScrollView
    private lazy var bookstoreImageScrollView = detailBookstoreView.bookstoreImageScrollView
    private lazy var imagePageControl = detailBookstoreView.imagePageControl
    
    private lazy var bookmarkButton = detailBookstoreView.bookmarkButton
    private lazy var isBookmarked = detailBookstoreView.isBookmarked
    
    var navigationBarAppearance: UINavigationBarAppearance = {
        let navigationBarAppearance = UINavigationBarAppearance()
        // 네비게이션 바의 색을 수동으로 주기 위해 배경색, 그림자 제거
        navigationBarAppearance.configureWithTransparentBackground()
        return navigationBarAppearance
    }()
    
    private lazy var navigationBarRightButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = isBookmarked ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        button.style = .plain
        button.target = self
        button.action = #selector(bookmarkButtonTapped)
        return button
    }()
    
    override func loadView() {
        view = detailBookstoreView
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBookstore()
        setupNavigationBar()
        setupTabbar()
        setupAddTarget()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        updateUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupBookstoreImages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
        // MARK: Task cancellation
        imageRequestTask?.cancel()
    }
    
    // MARK: Helpers
    private func setupBookstore() {
        detailBookstoreView.bookstore = bookstore
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor(named: "kindyPrimaryGreen")
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setupTabbar() {
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupAddTarget() {
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        mainScrollView.delegate = self
        bookstoreImageScrollView.delegate = self
    }
    
    // 서점 이미지 불러오기
    private func setupBookstoreImages() {
        imagePageControl.numberOfPages = bookstore?.images?.count ?? 1
        bookstoreImageScrollView.contentSize.width = view.frame.width * CGFloat(bookstore?.images?.count ?? 1)
        
        for i in 0..<(bookstore?.images?.count ?? 0) {
            self.imageRequestTask = Task {
                if let image = try? await firestoreManager.fetchImage(with: bookstore?.images?[i]) {
                    let imageView = UIImageView()
                    imageView.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: bookstoreImageScrollView.frame.width, height: bookstoreImageScrollView.frame.height)
                    imageView.image = image
                    bookstoreImageScrollView.addSubview(imageView)
                }
                imageRequestTask = nil
            }
        }
    }
    
    @objc private func bookmarkButtonTapped() {
        if let user = user {
            if user.bookmarkedBookstores.contains(bookstore?.id ?? "nil") {
                let bookmarkedBookstores = user.bookmarkedBookstores.filter{ $0 != bookstore?.id ?? "nil" }
                self.user!.bookmarkedBookstores = bookmarkedBookstores
                if updateBookmarkData(email: user.email, provider: user.provider, bookmarkedBookstores: bookmarkedBookstores) {
                    isBookmarked = false
                    bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
                } else {
                    print("fail delete bookmark")
                }
            } else {
                self.user!.bookmarkedBookstores.append(bookstore?.id ?? "nil")
                let bookmarkedBookstores = self.user!.bookmarkedBookstores
                if updateBookmarkData(email: user.email, provider: user.provider, bookmarkedBookstores: bookmarkedBookstores) {
                    isBookmarked = true
                    bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                } else {
                    print("fail add bookmark")
                }
            }
        } else {
            let alertForSignIn = UIAlertController(title: "로그인이 필요한 기능입니다", message: "로그인하시겠습니까?", preferredStyle: .alert)
            let action = UIAlertAction(title: "네", style: .default, handler: { _ in
                let signInViewController = SignInViewController()
                self.navigationController?.pushViewController(signInViewController, animated: true)
            })
            let cancel = UIAlertAction(title: "아니오", style: .destructive)
            alertForSignIn.addAction(cancel)
            alertForSignIn.addAction(action)
            present(alertForSignIn, animated: true, completion: nil)
        }
    }
    
    // viewWillAppear에서 User 정보 업데이트 해주기
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
    
    // MARK: 추후 데이터 수정 시 true False 반환하게 만들기
    private func updateBookmarkData(email: String, provider: String, bookmarkedBookstores: [String]) -> Bool {
        let isSuccess = true
        bookmarkUpdateTask?.cancel()
        bookmarkUpdateTask = Task {
            try? await firestoreManager.updateBookmark(email: email, provider: provider, bookmarkedBookstores: bookmarkedBookstores)
        }
        bookmarkUpdateTask = nil
        return isSuccess
    }
}

extension DetailBookstoreViewController: UIScrollViewDelegate {
    
    // 이미지 스크롤 했을때
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        // 스크롤이 메인스크롤이라면 네비게이션바 수정
        case mainScrollView:
            let currentScrollYOffset = scrollView.contentOffset.y
            
            // 밑으로 내릴수록 네비게이션 바의 배경색을 하얗게 변경
            if currentScrollYOffset > defaultScrollYOffset {
                navigationBarAppearance.backgroundColor = .init(white: currentScrollYOffset / 175, alpha: currentScrollYOffset / 175)
                navigationBarAppearance.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: ((currentScrollYOffset / 175) * 0.3))
            // 상단 화면을 보고 있으면 네비게이션 바 안보이게 변경
            } else {
                navigationBarAppearance.backgroundColor = .clear
                navigationBarAppearance.shadowColor = .clear
            }
            setNavigationBarAppearance()
            
            // 서점 이름을 가리는 순간 서점 이름과 북마크 버튼 네비게이션 바에 표시
            if currentScrollYOffset >= 230 {
                guard let bookstore = bookstore else { return }
                navigationController?.navigationBar.topItem?.title = "\(bookstore.name)"
                navigationItem.rightBarButtonItem = navigationBarRightButton
            } else {
                navigationController?.navigationBar.topItem?.title = ""
                navigationItem.rightBarButtonItem = nil
            }
            
        // 스크롤이 서점 이미지 스크롤이라면 현재 페이지 변경
        case bookstoreImageScrollView:
            let currentValue = scrollView.contentOffset.x / scrollView.frame.size.width
            setupPageControlSelectedPage(currentPage: Int(round(currentValue)))
            
        default:
            print("ScrollView Error!")
            break
        }
    }
    
    // 네비게이션 바 모습 변경
    private func setNavigationBarAppearance() {
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    // 현재 이미지의 페이지에 따라 pageControl의 currentPage 변경
    private func setupPageControlSelectedPage(currentPage: Int) {
        imagePageControl.currentPage = currentPage
    }
    
}
