//
//  HomeViewController.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/17.
//

import UIKit
import CoreLocation

final class HomeViewController: UIViewController {
    
    // MARK: Tasks
    var bookstoresTask: Task<Void, Never>?
    var curationsTask: Task<Void, Never>?
    var bookmarkedBookstoresTask: Task<Void, Never>?
    var imagesTask: Task<Void, Never>?
    
    deinit {
        bookstoresTask?.cancel()
        curationsTask?.cancel()
        bookmarkedBookstoresTask?.cancel()
        imagesTask?.cancel()
    }
    
    let locationManager = CLLocationManager()
    
    var model = Model()
    
    enum SupplementaryViewKind {
        static let header = "header"
    }
    
    // MARK: - Collection View
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavBarButtonItems()
        
        // MARK: Configuration
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        configureRefreshControl()
        
        // MARK: Delegate
        collectionView.delegate = self
        
        // MARK: Location Manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        updateCurations()
        updateBookstores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBookmarkedBookstores()
        
        // MARK: Bar Appearance
        configureTabBarAppearance()
        // 서점 상세화면으로 넘어갔다 오면 상세화면의 설정이 적용되기에 재설정
        tabBarController?.tabBar.isHidden = false
        configureNavBarAppearance()
        
        dataSource.apply(snapshot)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // MARK: Task cancellation
        curationsTask?.cancel()
        bookstoresTask?.cancel()
        bookmarkedBookstoresTask?.cancel()
        imagesTask?.cancel()
    }
    
    // MARK:  - Navigation Bar
    
    private func createNavBarButtonItems() {
        let resizedImage = UIImage(named: "KindyLogo")?.resizeImage(size: CGSize(width: 80, height: 20)).withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(scrollToTop))
        
        let bellButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(bellButtonTapped))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        
        bellButton.tintColor = .black
        searchButton.tintColor = .black
        
        // TODO: 알림 버튼 추가
        navigationItem.rightBarButtonItems = [searchButton]
    }
    
    @objc private func scrollToTop() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    // 네비게이션 바의 검색 버튼이 눌렸을때 실행되는 함수
    @objc private func searchButtonTapped() {
        let homeSearchViewController = SearchViewController()
        homeSearchViewController.setupData(items: model.bookstores, itemType: .bookstoreType, kinditorOfCuration: [:])
        show(homeSearchViewController, sender: nil)
    }
    
    // 네비게이션 바의 종 버튼이 눌렸을때 실행되는 함수
    @objc private func bellButtonTapped() { }
    
    // MARK: - Refresh Control
    
    private func configureRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        updateBookstores()
        collectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Update
    
    private func updateBookstores() {
        bookstoresTask?.cancel()
        bookstoresTask = Task {
            if let bookstores = try? await BookstoreRequest().fetch() {
                // 전체 데이터에 추가
                model.bookstores = bookstores
                
                switch locationManager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    model.nearbyBookstores = sortBookstoresByMyLocation(bookstores, showOnlyThreeItems: true).map { .nearbyBookstore($0) }
                default:
                    model.nearbyBookstores = []
                }
                
                var shuffledBookstores = bookstores.shuffled()
                var featuredBookstores = [Bookstore]()
                
                for _ in 0..<5 {
                    featuredBookstores.append(shuffledBookstores.removeLast())
                }
                
                model.featuredBookstores = featuredBookstores.map { .featuredBookstore($0) }
            } else {
                model.bookstores = []
                model.featuredBookstores = []
            }
            dataSource.apply(snapshot)
            
            bookstoresTask = nil
        }
    }
    
    private func updateBookmarkedBookstores() {
        bookmarkedBookstoresTask?.cancel()
        bookmarkedBookstoresTask = Task {
            if let bookmarkedBookstores = try? await BookstoreRequest().fetchBookmarkedBookstores() {
                model.bookmarkedBookstores = bookmarkedBookstores.map { .bookmarkedBookstore($0) }
            } else {
                model.bookmarkedBookstores = []
            }
            dataSource.apply(snapshot)
            
            bookmarkedBookstoresTask = nil
        }
    }
    
    private func updateCurations() {
        curationsTask?.cancel()
        curationsTask = Task {
            if let curations = try? await CurationRequest().fetch() {
                model.curations = curations
                model.curation = [curations.randomElement() ?? Curation.error].map { .curation($0) }
            } else {
                model.curations = []
            }
            dataSource.apply(snapshot)
            
            curationsTask = nil
        }
    }
}
