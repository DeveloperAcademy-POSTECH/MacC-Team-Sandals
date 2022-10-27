//
//  BookmarkCollectionViewCell.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/10/23.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    
    private var bookstore: Bookstore?
    private var imageData: [String] = ["testImage"]
    private var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    private var index: Int = -1
    
    weak var delegate: BookmarkDelegate?
    
    private let imageCarouselCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.layer.cornerRadius = 8
        collectionView.clipsToBounds = true
        collectionView.showsHorizontalScrollIndicator =  false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
       let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        button.tintColor = UIColor(named: "kindyGreen")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
     }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageCarouselCollectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(labelStackView)
        contentView.addSubview(bookmarkButton)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        setupCollectionView()
        setupPageControlUI()
        setupButtonUI()
        setupLabelStackView()
        
        addTarget()
    }
    
    func setupCollectionView() {
        let height = (frame.width - 32) * 1.0558
        imageCarouselCollectionView.register(ImageCarouselCollectionViewCell.self, forCellWithReuseIdentifier: ImageCarouselCollectionViewCell.identifier)
        imageCarouselCollectionView.delegate = self
        imageCarouselCollectionView.dataSource = self
        NSLayoutConstraint.activate([
            imageCarouselCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageCarouselCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageCarouselCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            imageCarouselCollectionView.heightAnchor.constraint(equalToConstant: height),
            
        ])
    }
    
    func setupPageControlUI() {
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: imageCarouselCollectionView.bottomAnchor, constant: -16)
        ])
    }
    
    func setupButtonUI() {
        NSLayoutConstraint.activate([
            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            bookmarkButton.topAnchor.constraint(equalTo: imageCarouselCollectionView.bottomAnchor, constant: 24),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 23),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func setupLabelStackView() {
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(addressLabel)
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: imageCarouselCollectionView.bottomAnchor, constant: 16),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            labelStackView.trailingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor),
            
        ])
    }
    // MARK: 추후 argument를 Bookstore 타입으로 바꿔 받아, 각 항목에 적용 예정
    func configureCell(_ bookstore: Bookstore, _ index: Int) {
        self.bookstore = bookstore
        titleLabel.text = bookstore.name
        addressLabel.text = bookstore.address
        self.index = index
    }
    // BookmarkButton, labelStackView에 액션 추가하기
    private func addTarget() {
        bookmarkButton.addTarget(self, action: #selector(deleteBookmark), for: .touchUpInside)
        let tab = UITapGestureRecognizer(target: self, action: #selector(selectLabel))
        labelStackView.isUserInteractionEnabled = true
        labelStackView.addGestureRecognizer(tab)
    }
    
    @objc private func deleteBookmark() {
        delegate?.deleteBookmark(bookstore!)
    }

    @objc private func selectLabel() {
        delegate?.selectItem(bookstore!)
    }
}

extension BookmarkCollectionViewCell {
    // ImageCarousel 의 데이터가 입력되면 Layout 재설정 및 컬렉션뷰 리로드
    public func configureCarouselView(with data: [String]) {
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: frame.width, height: frame.height)
        carouselLayout.sectionInset = .zero
        carouselLayout.minimumLineSpacing = .zero
        imageCarouselCollectionView.collectionViewLayout = carouselLayout
        imageData = data
        imageCarouselCollectionView.reloadData()
        setupPageControl(data.count)
    }
    // Image 갯수에 따라 PageControl이 표현해야할 총 갯수 변환해준다
    func setupPageControl(_ totalCount: Int) {
        pageControl.numberOfPages = totalCount
    }
}

extension BookmarkCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCarouselCollectionViewCell.identifier, for: indexPath) as? ImageCarouselCollectionViewCell else {return UICollectionViewCell()}
        cell.configureCell(image: imageData[indexPath.row])
        return cell
    }
    // PageControl과 ImageCarouselView와 싱크를 맞추기 위해 스크롤 추적
    // 스크롤 종료 후 페이징에 의해 추가 스크롤이 된 후 멈출 때
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    
    // 유저가 스크롤 하는 것을 멈추는 순간
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
    }
    // 스크롤이 되는 도중
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
}



extension BookmarkCollectionViewCell {
    // ImageCarouselCollectionView의 현재 페이지를 구한다.
    func getCurrentPage() -> Int {
        let visibleRect = CGRect(origin: imageCarouselCollectionView.contentOffset, size: imageCarouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = imageCarouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        return currentPage
    }
}
