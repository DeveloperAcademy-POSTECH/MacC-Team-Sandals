//
//  DetailBookstoreView.swift
//  Kindy
//
//  Created by WooriJoon on 2022/10/22.
//

import UIKit
import MapKit

// TODO: didSet 이용하여 값 넘겨받을 프로퍼티 생성
final class DetailBookstoreView: UIView {
    
    private let padding16: CGFloat = 16
    private let padding24: CGFloat = 24
    
    var bookstoreImages = [UIImage(named: "testImage"), UIImage(named: "testImage"), UIImage(named: "testImage"), UIImage(named: "testImage")]
    var isBookmarked: Bool = false
    private let bookstoreCoordinate = CLLocationCoordinate2D(latitude: 36.0090456, longitude: 129.3331438)
    
    // 전체 화면을 덮는 스크롤뷰
    let mainScrollView: UIScrollView = {
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
    let bookstoreImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // 서점 이미지 페이지 컨트롤
    lazy var imagePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = bookstoreImages.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // 서점 이름 레이블
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "달팽이책방"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // TODO: 버튼 키우기
    // 북마크 버튼
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        isBookmarked ? button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal) : button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = UIColor(named: "kindyGreen")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 서점 이름과 북마크 버튼을 묶는 스택뷰
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, bookmarkButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 서점의 짧은 주소 레이블
    private let shortAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "경상북도 포항시 남구"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(named: "kindyGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 서점 이름과 요약 정보 사이의 디바이더
    private let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "kindyLightGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 전화기 아이콘
    private let telephoneIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "phone")
        imageView.contentMode = .center
        imageView.tintColor = UIColor(named: "kindyGray")
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
        let stackView = UIStackView(arrangedSubviews: [telephoneIconImageView, telephoneNumberLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // TODO: 인스타그램 없을시 숨기기 구현
    // 인스타그램 아이콘
    private let instagrameIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "instagramIcon")
        imageView.tintColor = UIColor(named: "kindyGray")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 인스타그램 레이블
    private let instagramLabel: UILabel = {
        let label = UILabel()
        label.text = "@bookshopsnail"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 인스타그램 스택뷰
    private lazy var instagramStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [instagrameIconImageView, instagramLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 운영시간 아이콘
    private let businessHourIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.contentMode = .center
        imageView.tintColor = UIColor(named: "kindyGray")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 운영시간 레이블
    private let businessHourLabel: UILabel = {
        let label = UILabel()
        label.text = """
        월, 화, 수 9:00 - 20:00
        목, 금 9:00 - 20:00
        토,일 9:00 - 20:00
        """
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.setLineSpacing(lineSpacing: 8) // 라인 간격 조절
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 운영시간 스택뷰
    private lazy var businessHourStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [businessHourIconImageView, businessHourLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 서점의 기본 정보를 담고있는 스택뷰
    private lazy var summaryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [telephoneStackView, instagramStackView, businessHourStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 요약 정보와 서점 설명 사이의 디바이더
    private let middleDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "kindyLightGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 서점 상세설명 레이블
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Happiness is good health and a bad memory.Time moves in one direction, memory in another. History is not a burden on the memory but an illumination of the soul. Happiness is good health and a bad memory. Time moves in one direction, memory in another. History is not a burden on the memory but an illumination of the soul. History is not a burden on the memory but an illumination of the soul."
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 서점 설명과 맵 뷰 사이의 디바이더
    private let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "kindyLightGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 지도 아이콘 이미지 뷰
    private let mapIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "map")
        imageView.contentMode = .center
        imageView.tintColor = UIColor(named: "kindyGray")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 하단 서점 상세 주소 레이블
    private let address: UILabel = {
        let label = UILabel()
        label.text = "경상북도 포항시 남구 효자동길10번길 32"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mapIconImageView, address])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let bookstoreMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 8
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var bookstorePin: MKPointAnnotation = {
        let pin = MKPointAnnotation()
        guard let bookstoreName = nameLabel.text else { return pin }
        pin.title = bookstoreName
        pin.coordinate = bookstoreCoordinate
        return pin
    }()
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        setupMapView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        bookstoreImageScrollView.backgroundColor = .systemGray5

        contentView.addSubview(bookstoreImageScrollView)
        contentView.addSubview(imagePageControl)
        contentView.addSubview(nameStackView)
        contentView.addSubview(shortAddressLabel)
        contentView.addSubview(topDivider)
        contentView.addSubview(summaryStackView)
        contentView.addSubview(middleDivider)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(bottomDivider)
        contentView.addSubview(addressStackView)
        contentView.addSubview(bookstoreMapView)
        
        NSLayoutConstraint.activate([
            // 메인 스크롤뷰 오토레이아웃 설정
            mainScrollView.topAnchor.constraint(equalTo: topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),

            // 컨텐츠뷰 내부 오토레이아웃 설정
            bookstoreImageScrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -100),
            bookstoreImageScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookstoreImageScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookstoreImageScrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.436),
            
            imagePageControl.topAnchor.constraint(equalTo: bookstoreImageScrollView.bottomAnchor, constant: -24),
            imagePageControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagePageControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagePageControl.bottomAnchor.constraint(equalTo: bookstoreImageScrollView.bottomAnchor, constant: -16),
            
            nameStackView.topAnchor.constraint(equalTo: bookstoreImageScrollView.bottomAnchor, constant: padding24),
            nameStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding16),
            nameStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding16),
            nameStackView.heightAnchor.constraint(equalToConstant: 36),
            
            shortAddressLabel.topAnchor.constraint(equalTo: nameStackView.bottomAnchor),
            shortAddressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding16),
            shortAddressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding16),
            shortAddressLabel.heightAnchor.constraint(equalToConstant: 25),

            topDivider.topAnchor.constraint(equalTo: shortAddressLabel.bottomAnchor, constant: padding24),
            topDivider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            topDivider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (padding16 * 2)),
            topDivider.heightAnchor.constraint(equalToConstant: 1),
            
            telephoneIconImageView.widthAnchor.constraint(equalToConstant: 22),
            telephoneIconImageView.heightAnchor.constraint(equalToConstant: 22),
            instagrameIconImageView.widthAnchor.constraint(equalToConstant: 22),
            instagrameIconImageView.heightAnchor.constraint(equalToConstant: 22),
            businessHourIconImageView.widthAnchor.constraint(equalToConstant: 22),
            businessHourIconImageView.heightAnchor.constraint(equalToConstant: 22),
            
            summaryStackView.topAnchor.constraint(equalTo: topDivider.bottomAnchor, constant: padding24),
            summaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding16),
            summaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding16),
            
            middleDivider.topAnchor.constraint(equalTo: summaryStackView.bottomAnchor, constant: padding24),
            middleDivider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            middleDivider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (padding16 * 2)),
            middleDivider.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionLabel.topAnchor.constraint(equalTo: middleDivider.bottomAnchor, constant: padding24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding16),
            
            bottomDivider.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding24),
            bottomDivider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bottomDivider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (padding16 * 2)),
            bottomDivider.heightAnchor.constraint(equalToConstant: 1),
            
            addressStackView.topAnchor.constraint(equalTo: bottomDivider.bottomAnchor, constant: padding24),
            addressStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding16),
            addressStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding16),
            
            bookstoreMapView.topAnchor.constraint(equalTo: addressStackView.bottomAnchor, constant: padding24),
            bookstoreMapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding16),
            bookstoreMapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding16),
            bookstoreMapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.36),
            bookstoreMapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
        ])
    }
    
    private func setupMapView() {
        bookstoreMapView.setRegion(MKCoordinateRegion(center: bookstoreCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
        bookstoreMapView.addAnnotation(bookstorePin)
    }
}
