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
    
    private let detailBookstoreView = DetailBookstoreView()
    
    private lazy var mainScrollView = detailBookstoreView.mainScrollView
    private lazy var bookstoreImageScrollView = detailBookstoreView.bookstoreImageScrollView
    private lazy var bookstoreImages = detailBookstoreView.bookstoreImages
    private lazy var imagePageControl = detailBookstoreView.imagePageControl
    
    private lazy var bookmarkButton = detailBookstoreView.bookmarkButton
    private lazy var isBookmarked = detailBookstoreView.isBookmarked
    
    private var navigationBarAppearance: UINavigationBarAppearance = {
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
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTabbar()
        setupAddTarget()
        setupDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupBookstoreImages()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = UIColor(named: "kindyGreen")
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setupTabbar() {
        self.tabBarController?.tabBar.isHidden = true
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
        for i in 0..<bookstoreImages.count {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: bookstoreImageScrollView.frame.width, height: bookstoreImageScrollView.frame.height)
            imageView.image = bookstoreImages[i]
            bookstoreImageScrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
            bookstoreImageScrollView.addSubview(imageView)
        }
    }
    
    @objc private func bookmarkButtonTapped() {
        isBookmarked.toggle()
        isBookmarked ? bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal) : bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        navigationBarRightButton.image = isBookmarked ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
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
                self.navigationController?.navigationBar.topItem?.title = "달팽이책방"
                self.navigationItem.rightBarButtonItem = self.navigationBarRightButton
            } else {
                self.navigationController?.navigationBar.topItem?.title = ""
                self.navigationItem.rightBarButtonItem = nil
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
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.compactAppearance = navigationBarAppearance
    }
    
    // 현재 이미지의 페이지에 따라 pageControl의 currentPage 변경
    private func setupPageControlSelectedPage(currentPage: Int) {
        imagePageControl.currentPage = currentPage
    }
    
}
