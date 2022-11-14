//
//  DetailBookstoreView.swift
//  Kindy
//
//  Created by WooriJoon on 2022/10/22.
//

import UIKit
import MapKit

// FIXME: 주석처리한 부분과 기타 디테일을 수정해주세용
final class DetailBookstoreView: UIView {
    
    private let padding16: CGFloat = 16
    private let padding24: CGFloat = 24
    
    var bookstore: Bookstore? {
        didSet {
            setupBookstore()
        }
    }
    
    var isBookmarked: Bool = false
    private var bookstoreCoordinate = CLLocationCoordinate2D(latitude: 36.0090456, longitude: 129.3331438)
    
    // 전체 화면을 덮는 스크롤뷰
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
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
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // 서점 이름 레이블
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "책방"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "kindyPrimaryGreen")
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
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "주소"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor(named: "kindyGray")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameStackView, addressLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        label.text = "010-1234-567"
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
    
    // 인스타그램 주소 버튼
    private lazy var instagramButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 인스타그램 스택뷰
    private lazy var instagramStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [instagrameIconImageView, instagramButton])
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
        운영시간
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
    private lazy var infoSummaryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [telephoneStackView, instagramStackView, businessHourStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 서점의 기본 정보와 탑 디바이더를 담고있는 스택뷰
    private lazy var summaryStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topDivider, infoSummaryStackView])
        stackView.axis = .vertical
        stackView.spacing = padding24
        stackView.distribution = .fill
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
        label.text = "상세설명"
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 서점 상세설명과 미들 디바이더를 담고 있는 스택뷰
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [middleDivider, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = padding24
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    private let mapAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "경상북도 포항시 남구 지곡로 83"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mapIconImageView, mapAddressLabel])
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
    
    private lazy var bookstoreMapStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bottomDivider, addressStackView, bookstoreMapView])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(mainScrollView)
        bookstoreImageScrollView.backgroundColor = .lightGray
        
        mainScrollView.addSubview(bookstoreImageScrollView)
        mainScrollView.addSubview(imagePageControl)
        mainScrollView.addSubview(headerStackView)
        mainScrollView.addSubview(summaryStackView)
        mainScrollView.addSubview(descriptionStackView)
        mainScrollView.addSubview(bookstoreMapStackView)
        
        // 고정값 UI들 설정
        setupDividerConstraints()
        setupIconConstraints()
        
        NSLayoutConstraint.activate([
            // 메인 스크롤뷰 설정
            mainScrollView.topAnchor.constraint(equalTo: topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 서점 이미지뷰 설정
            bookstoreImageScrollView.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: -92),
            bookstoreImageScrollView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            bookstoreImageScrollView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            bookstoreImageScrollView.heightAnchor.constraint(equalToConstant: 368),
            
            imagePageControl.topAnchor.constraint(equalTo: bookstoreImageScrollView.bottomAnchor, constant: -padding24),
            imagePageControl.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            imagePageControl.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            imagePageControl.bottomAnchor.constraint(equalTo: bookstoreImageScrollView.bottomAnchor, constant: -padding16),
            
            // 서점 이름, 짧은 주소, 북마크 버튼뷰
            nameStackView.heightAnchor.constraint(equalToConstant: 36),
            addressLabel.heightAnchor.constraint(equalToConstant: 25),
            headerStackView.topAnchor.constraint(equalTo: bookstoreImageScrollView.bottomAnchor, constant: padding24),
            headerStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: padding16),
            headerStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -padding16),
            
            // 탑 디바이더와 서점 기본 정보뷰
            summaryStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: padding24),
            summaryStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: padding16),
            summaryStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -padding16),
            
            // 미들 디바이더와 서점 상세 정보뷰
            descriptionStackView.topAnchor.constraint(equalTo: summaryStackView.bottomAnchor, constant: padding24),
            descriptionStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: padding16),
            descriptionStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -padding16),
            
            // 바텀 디바이더와 서점 지도뷰
            bookstoreMapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.36),
            bookstoreMapStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding24),
            bookstoreMapStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: padding16),
            bookstoreMapStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -padding16),
            bookstoreMapStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -100)
        ])
    }
    
    private func setupDividerConstraints() {
        NSLayoutConstraint.activate([
            topDivider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (padding16 * 2)),
            topDivider.heightAnchor.constraint(equalToConstant: 1),
            
            middleDivider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (padding16 * 2)),
            middleDivider.heightAnchor.constraint(equalToConstant: 1),
            
            bottomDivider.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (padding16 * 2)),
            bottomDivider.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    private func setupIconConstraints() {
        NSLayoutConstraint.activate([
            bookmarkButton.heightAnchor.constraint(equalToConstant: 36),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 32),
            
            telephoneIconImageView.widthAnchor.constraint(equalToConstant: 22),
            telephoneIconImageView.heightAnchor.constraint(equalToConstant: 22),
            
            instagrameIconImageView.widthAnchor.constraint(equalToConstant: 22),
            instagrameIconImageView.heightAnchor.constraint(equalToConstant: 22),
            
            businessHourIconImageView.widthAnchor.constraint(equalToConstant: 22),
            businessHourIconImageView.heightAnchor.constraint(equalToConstant: 22),
            
            mapIconImageView.widthAnchor.constraint(equalToConstant: 22),
            mapIconImageView.widthAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    private func setupBookstore() {
        guard let bookstore = self.bookstore else { return }
        nameLabel.text = bookstore.name
        addressLabel.text = bookstore.address
        isBookmarked ? bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal) : bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        telephoneNumberLabel.text = bookstore.contact.telNumber ?? "-"
        setupInstagramView()
        setupBusinessHourLabel()
        descriptionLabel.text = bookstore.description
        mapAddressLabel.text = bookstore.address
        setupMapView()
    }
    
    private func setupInstagramView() {
        guard let bookstore = self.bookstore else { return }
        guard let instagramURL = bookstore.contact.instagramURL else {
            instagramButton.setTitle("-", for: .normal)
            return
        }
        
        let instagramID = instagramURL.components(separatedBy: "/")[3]
        instagramButton.setTitle("@\(instagramID)", for: .normal)
        instagramButton.setUnderline()
        //        infoSummaryStackView.insertArrangedSubview(instagramStackView, at: 1)
    }
    
    private func setupBusinessHourLabel() {
        guard let bookstore = self.bookstore else { return }
        guard let notice = bookstore.businessHour.notice else {
            businessHourLabel.text = """
                월 \(bookstore.businessHour.monday ?? "휴무")
                화 \(bookstore.businessHour.tuesday ?? "휴무")
                수 \(bookstore.businessHour.wednesday ?? "휴무")
                목 \(bookstore.businessHour.thursday ?? "휴무")
                금 \(bookstore.businessHour.friday ?? "휴무")
                토 \(bookstore.businessHour.saturday ?? "휴무")
                일 \(bookstore.businessHour.sunday ?? "휴무")
                """
            return
        }
        businessHourLabel.text = """
            월 \(bookstore.businessHour.monday ?? "휴무")
            화 \(bookstore.businessHour.tuesday ?? "휴무")
            수 \(bookstore.businessHour.wednesday ?? "휴무")
            목 \(bookstore.businessHour.thursday ?? "휴무")
            금 \(bookstore.businessHour.friday ?? "휴무")
            토 \(bookstore.businessHour.saturday ?? "휴무")
            일 \(bookstore.businessHour.sunday ?? "휴무")
            \(notice)
            """
    }
    
    private func setupMapView() {
        guard let bookstore = self.bookstore else { return }
        
        bookstoreCoordinate = CLLocationCoordinate2D(latitude: bookstore.location.latitude, longitude: bookstore.location.longitude)
        bookstorePin.title = bookstore.name
        bookstorePin.coordinate = CLLocationCoordinate2D(latitude: bookstore.location.latitude, longitude: bookstore.location.longitude)
        
        bookstoreMapView.setRegion(MKCoordinateRegion(center: bookstoreCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
        bookstoreMapView.addAnnotation(bookstorePin)
    }
    
    @objc private func instagramButtonTapped() {
        guard let instagramAddress = bookstore?.contact.instagramURL else { return }
        guard let url = URL(string: instagramAddress) else { return }
        UIApplication.shared.open(url, options: [:])
    }
    
}
