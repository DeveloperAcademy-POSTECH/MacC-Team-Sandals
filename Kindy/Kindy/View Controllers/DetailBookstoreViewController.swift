//
//  DetailBookstoreViewController.swift
//  Kindy
//
//  Created by WooriJoon on 2022/10/21.
//

import UIKit
import MapKit

final class DetailBookstoreViewController: UIViewController {
    
    private let detailBookstoreView = DetailBookstoreView()
    
    private lazy var bookstoreImageScrollView = detailBookstoreView.bookstoreImageScrollView
    private lazy var bookstoreImages = detailBookstoreView.bookstoreImages
    
    private lazy var imagePageControl = detailBookstoreView.imagePageControl
    
    private lazy var bookmarkButton = detailBookstoreView.bookmarkButton
    private lazy var isBookmarked = detailBookstoreView.isBookmarked

    override func loadView() {
        view = detailBookstoreView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTabbar()
        setupAddTarget()
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
    
    // 서점 이미지 불러오기
    private func setupBookstoreImages() {
        bookstoreImageScrollView.delegate = self
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
    }
    
}

extension DetailBookstoreViewController: UIScrollViewDelegate {
    
    // 이미지 스크롤 했을때 현재 페이지 변경
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentValue = scrollView.contentOffset.x / scrollView.frame.size.width
        setupPageControlSelectedPage(currentPage: Int(round(currentValue)))
    }
    
    // 현재 이미지의 페이지에 따라 pageControl의 currentPage 변경
    func setupPageControlSelectedPage(currentPage: Int) {
        imagePageControl.currentPage = currentPage
    }
    
}
