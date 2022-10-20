//
//  DetailBookstoreViewController.swift
//  Kindy
//
//  Created by WooriJoon on 2022/10/21.
//

import UIKit

class DetailBookstoreViewController: UIViewController {
    
    var images = [UIImage(named: "testImage"), UIImage(named: "testImage"), UIImage(named: "testImage"), UIImage(named: "testImage")]
    
    var isBookmarked: Bool = false
    
    // 전체 화면을 덮는 스크롤뷰
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // mainScrollView를 채울 뷰
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 서점 이미지 페이징에서 사용할 스크롤뷰
    private let bookstoreImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // 서점 이미지 페이지 컨트롤
    private lazy var imagePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = images.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // 서점 이름 레이블
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "달팽이책방"
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 서점의 짧은 주소 레이블
    private let shortAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "경상북도 경주시"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 북마크 버튼
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        //        button.tintColor = UIColor(named: "kindyGreen")
        //        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 전화기 아이콘
    private lazy var telephoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "phone.fill")
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 전화번호 레이블
    private let telephoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "054-782-7653"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 전화 스택뷰
    private lazy var telephoneStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [telephoneImageView, telephoneNumberLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 이메일 아이콘
    private lazy var emailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "envelope.fill")
        imageView.tintColor = .black
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 이메일 레이블
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "wikidia32@naver.com"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "labelGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 이메일 스택뷰
    private lazy var emailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailImageView, emailLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 운영시간 아이콘
    private lazy var businessHourImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock.fill")
        imageView.tintColor = .black
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 운영시간 레이블
    private let businessHourLabel: UILabel = {
        let label = UILabel()
        label.text = "9:00 - 20:00"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "labelGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 운영시간 스택뷰
    private lazy var businessHourStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [businessHourImageView, businessHourLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 서점의 기본 정보를 담고있는 스택뷰
    private lazy var summaryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [telephoneStackView, emailStackView, businessHourStackView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 서점 상세설명 레이블
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Happiness is good health and a bad memory.Time moves in one direction, memory in another.History is not a burden on the memory but an illumination of the soul. Happiness is good health and a bad memory. Time moves in one direction, memory in another.History is not a burden on the memory but an illumination of the soul."
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 하단 서점 이름 레이블
    private let bottomNameLabel: UILabel = {
        let label = UILabel()
        label.text = "달팽이책방"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 하단 서점 상세 주소 레이블
    private let address: UILabel = {
        let label = UILabel()
        label.text = "경주 황리단길 23-2"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor(named: "labelGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // TODO: MapView 추가
    //    private let mapView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
    }
    
}
