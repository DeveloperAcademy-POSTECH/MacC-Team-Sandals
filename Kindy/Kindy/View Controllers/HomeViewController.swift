//
//  HomeViewController.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/17.
//

import UIKit
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class HomeViewController: UIViewController {
    
    // MARK: Tasks
    private var bookstoresTask: Task<Void, Never>?
    private var curationsTask: Task<Void, Never>?
    private var bookmarkedBookstoresTask: Task<Void, Never>?
    private var imagesTask: Task<Void, Never>?
    
    deinit {
        bookstoresTask?.cancel()
        curationsTask?.cancel()
        bookmarkedBookstoresTask?.cancel()
        imagesTask?.cancel()
    }
    
    private let locationManager = CLLocationManager()
    
    private var model = Model()
    
    enum SupplementaryViewKind {
        static let header = "header"
    }
    
    // MARK: - Collection View
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>!
    
    private var snapshot: NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item> {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        snapshot.appendSections([.curations])
        snapshot.appendItems(model.curation)
        
        snapshot.appendSections([.featured])
        snapshot.appendItems(model.featuredBookstores)
        
        switch locationManager.authorizationStatus {
        case .notDetermined, .denied, .restricted:
            snapshot.appendSections([.noPermission])
            snapshot.appendItems([.noPermission])
        default:
            snapshot.appendSections([.nearbys])
            snapshot.appendItems(model.nearbyBookstores)
        }
        
        if model.bookmarkedBookstores.isEmpty || !UserManager().isLoggedIn() {
            snapshot.appendSections([.emptyBookmarks])
            snapshot.appendItems([.noBookmarkedBookstore])
        } else {
            snapshot.appendSections([.bookmarks])
            snapshot.appendItems(model.bookmarkedBookstores)
        }
        
        snapshot.appendSections([.regions])
        snapshot.appendItems(model.regions)
        
        return snapshot
    }
    
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 큐레이션은 1번만 fetch
        updateCuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update()
        
        // MARK: Nav Bar Appearance
        // 서점 상세화면으로 넘어갔다 오면 상세화면의 네비게이션 바 설정이 적용되기에 재설정
        let customNavBarAppearance = UINavigationBarAppearance()
        customNavBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.standardAppearance = customNavBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = customNavBarAppearance
        navigationController?.navigationBar.compactAppearance = customNavBarAppearance
        
        // MARK: Tab Bar Appearance
        // 서점 상세화면으로 넘어갔다 오면 상세화면의 탭 바 설정이 적용되기에 재설정
        tabBarController?.tabBar.isHidden = false
        
        dataSource.apply(snapshot)
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
    
    func createNavBarButtonItems() {
        let scaledImage = UIImage(named: "KindyLogo")?.resizeImage(size: CGSize(width: 80, height: 20)).withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: scaledImage, style: .plain, target: nil, action: nil)
        
        let bellButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(bellButtonTapped))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        
        bellButton.tintColor = .black
        searchButton.tintColor = .black
        
        // TODO: 알림 버튼 추가
        navigationItem.rightBarButtonItems = [searchButton]
    }
    
    // 네비게이션 바의 검색 버튼이 눌렸을때 실행되는 함수
    @objc func searchButtonTapped() {
        let homeSearchViewController = SearchViewController()
        homeSearchViewController.setupData(items: model.bookstores, itemType: .bookstoreType, kinditorOfCuration: [:])
        show(homeSearchViewController, sender: nil)
    }
    
    // 네비게이션 바의 종 버튼이 눌렸을때 실행되는 함수
    @objc func bellButtonTapped() {
        
    }
    
    // MARK: - Refresh Control
    
    func configureRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        update()
        
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Update
    
    func update() {
        bookstoresTask?.cancel()
        bookstoresTask = Task {
            if let bookstores = try? await BookstoreRequest().fetch() {
                // 전체 데이터에 추가
                model.bookstores = bookstores
                
                switch locationManager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    model.nearbyBookstores = sortBookstoresByMyLocation(bookstores).map { .nearbyBookstore($0) }
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
    
    func updateCuration() {
        curationsTask?.cancel()
        curationsTask = Task {
            if let curations = try? await CurationRequest().fetch() {
                model.curations = curations
                model.curation = [curations.randomElement()!].map { .curation($0) }
            } else {
                model.curations = []
            }
            dataSource.apply(snapshot)
            
            curationsTask = nil
        }
    }
    
    // MARK: - Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            
            // 재사용되는 edge inset을 정의했습니다.
            let padding8: CGFloat = 8
            let padding16: CGFloat = 16
            
            // MARK: Section Header
            let headerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(36)
            )
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: SupplementaryViewKind.header,
                alignment: .top
            )
            headerItem.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: padding16, bottom: .zero, trailing: padding16)
            
            // MARK: Item Size
            let fullSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            
            // MARK: Content Insets
            let leading16ContentInsetsForItem = NSDirectionalEdgeInsets(top: .zero, leading: padding16, bottom: .zero, trailing: .zero)
            let sectionContentInsets = NSDirectionalEdgeInsets(top: padding8, leading: .zero, bottom: padding8, trailing: .zero)
            
            switch section {
            case .curations:
                let item = NSCollectionLayoutItem(layoutSize: fullSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .estimated(408)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = sectionContentInsets
                
                return section
            case .featured:
                let item = NSCollectionLayoutItem(layoutSize: fullSize)
                item.contentInsets = leading16ContentInsetsForItem
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(326),
                    heightDimension: .estimated(168)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = sectionContentInsets
                
                return section
            case .nearbys:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1/3)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .estimated(312)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 3
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = sectionContentInsets
                
                return section
            case .bookmarks:
                let item = NSCollectionLayoutItem(layoutSize: fullSize)
                item.contentInsets = leading16ContentInsetsForItem
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(2/5),
                    heightDimension: .estimated(219)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = sectionContentInsets
                
                return section
            case .regions:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/2),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(50)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 2
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = sectionContentInsets
                
                return section
            case .noPermission, .emptyBookmarks:
                let item = NSCollectionLayoutItem(layoutSize: fullSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(150)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = sectionContentInsets
                
                return section
            }
        }
        
        return layout
    }
    
    // MARK: - Data Source
    
    private func configureDataSource() {
        // MARK: Cell Registration
        let curationCellRegistration = UICollectionView.CellRegistration<CurationCell, ViewModel.Item> { cell, indexPath, item in
            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.curation?.mainImage) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
            
            cell.configureCell(item.curation!)
        }
        
        let bookstoreCellRegistration = UICollectionView.CellRegistration<FeaturedBookstoreCell, ViewModel.Item> { cell, indexPath, item in
            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
            
            cell.configureCell(item.bookstore!)
        }
        
        let nearbyBookstoreCellRegistration = UICollectionView.CellRegistration<NearByBookstoreCell, ViewModel.Item> { cell, indexPath, item in
            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
            
            cell.configureCell(item.bookstore!)
        }
        
        let bookmarkedBookstoreCellRegistration = UICollectionView.CellRegistration<BookmarkedBookstoreCell, ViewModel.Item> { cell, indexPath, item in
            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
            
            cell.configureCell(item.bookstore!)
        }
        
        let regionNameCellRegistration = UICollectionView.CellRegistration<RegionNameCell, ViewModel.Item> { cell, indexPath, item in
            let isTopCell = !(indexPath.item < 2)
            let isOddNumber = indexPath.item % 2 == 1
            
            cell.configureCell(item.region!, hideTopLine: isTopCell, hideRightLine: isOddNumber)
        }
        
        let noPermissionCellRegistration = UICollectionView.CellRegistration<NoPermissionCell, ViewModel.Item> { _, _, _ in }
        
        let exceptionBookmarkCellRegistration = UICollectionView.CellRegistration<ExceptionBookmarkCell, ViewModel.Item> { cell, indexPath, item in
            cell.label.text = UserManager().isLoggedIn() ? "북마크한 서점이 아직 없어요" : "로그인 후 이용할 수 있는 서비스입니다."
        }
        
        // MARK: Supplementary View Registration
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(elementKind: SupplementaryViewKind.header) { headerView, kind, indexPath in
            
            headerView.delegate = self

            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let sectionName: String
            let hideSeeAllButton: Bool
            let hideBottomStackView: Bool
            
            switch section {
            case .curations:
                sectionName = "킨디터 Pick"
                hideSeeAllButton = true
                hideBottomStackView = true
            case .featured:
                sectionName = "이런 서점은 어때요"
                hideSeeAllButton = true
                hideBottomStackView = true
            case .nearbys, .noPermission:
                sectionName = "내 주변 서점"
                
                switch self.locationManager.authorizationStatus {
                case .notDetermined, .denied, .restricted:
                    hideSeeAllButton = true
                default:
                    hideSeeAllButton = false
                }
                hideBottomStackView = false
                
                Task {
                    try await headerView.regionLabel.text = self.fetchMyLocation()
                }
            case .bookmarks, .emptyBookmarks:
                sectionName = "북마크 한 서점"
                hideSeeAllButton = false
                hideBottomStackView = true
            case .regions:
                sectionName = "지역별 서점"
                hideSeeAllButton = true
                hideBottomStackView = true
            }
            
            headerView.configure(title: sectionName, hideSeeAllButton: hideSeeAllButton, hideBottomStackView: hideBottomStackView, sectionIndex: indexPath.section)
        }
        
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .curations:
                return collectionView.dequeueConfiguredReusableCell(using: curationCellRegistration, for: indexPath, item: item)
            case .featured:
                return collectionView.dequeueConfiguredReusableCell(using: bookstoreCellRegistration, for: indexPath, item: item)
            case .nearbys:
                return collectionView.dequeueConfiguredReusableCell(using: nearbyBookstoreCellRegistration, for: indexPath, item: item)
            case .bookmarks:
                return collectionView.dequeueConfiguredReusableCell(using: bookmarkedBookstoreCellRegistration, for: indexPath, item: item)
            case .regions:
                return collectionView.dequeueConfiguredReusableCell(using: regionNameCellRegistration, for: indexPath, item: item)
            case .noPermission:
                return collectionView.dequeueConfiguredReusableCell(using: noPermissionCellRegistration, for: indexPath, item: item)
            case .emptyBookmarks:
                return collectionView.dequeueConfiguredReusableCell(using: exceptionBookmarkCellRegistration, for: indexPath, item: item)
            }
        }
        
        // MARK: Supplementary View Provider
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        dataSource.apply(snapshot)
    }
}

// MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        
        switch section {
        case .curations:
            let curation = model.curation.map { $0.curation! }.first!
            let curationViewController = PagingCurationViewController(curation: curation)
            curationViewController.modalPresentationStyle = .overFullScreen
            curationViewController.modalTransitionStyle = .crossDissolve
            
            present(curationViewController, animated: true)
        case .featured:
            let featuredBookstores = model.featuredBookstores.map { $0.bookstore! }
            let detailBookstoreViewController = DetailBookstoreViewController()
            detailBookstoreViewController.bookstore = featuredBookstores[indexPath.item]
            
            show(detailBookstoreViewController, sender: nil)
        case .nearbys:
            let bookstores = model.nearbyBookstores.map { $0.bookstore! }
            let detailBookstoreViewController = DetailBookstoreViewController()
            detailBookstoreViewController.bookstore = bookstores[indexPath.item]
            
            show(detailBookstoreViewController, sender: nil)
        case .bookmarks:
            let bookmarkedBookstores = model.bookmarkedBookstores.map { $0.bookstore! }
            let detailBookstoreViewController = DetailBookstoreViewController()
            detailBookstoreViewController.bookstore = bookmarkedBookstores[indexPath.item]

            show(detailBookstoreViewController, sender: nil)
        case .regions:
            let region = model.regions[indexPath.item].region
            let regionViewController = RegionViewController()
            regionViewController.setupData(regionName: region!, items: model.bookstores)

            show(regionViewController, sender: nil)
        default:
            return
        }
    }
}

// MARK: - Section Header Delegate

extension HomeViewController: SectionHeaderDelegate {

    func segueWithSectionIndex(_ sectionIndex: Int) {
        switch sectionIndex {
        case 2:
            let nearbyBookstores = model.nearbyBookstores.map { $0.bookstore! }
            let nearbyViewController = NearbyViewController()
            nearbyViewController.setupData(items: nearbyBookstores)
            show(nearbyViewController, sender: nil)
        case 3:
            let bookmarkedBookstores = model.bookmarkedBookstores.map { $0.bookstore! }
            let bookmarkViewController = BookmarkViewController()
            bookmarkViewController.setupData(items: bookmarkedBookstores)
            show(bookmarkViewController, sender: nil)
        default:
            return
        }
    }
}


// MARK: - Scroll View Delegate

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (velocity.y > 0) {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    
    // 내 위치를 기준으로 서점 정렬
    private func sortBookstoresByMyLocation(_ bookstores: [Bookstore]) -> [Bookstore] {
        guard let myLocation = locationManager.location?.coordinate as? CLLocationCoordinate2D else { return [] }
        var sortedBookstores = bookstores
        
        for i in 0..<bookstores.count {
            sortedBookstores[i].distance = Int(myLocation.distance(from: CLLocationCoordinate2D(latitude: sortedBookstores[i].location.latitude, longitude: sortedBookstores[i].location.longitude))) / 1000
        }
        // TODO: 거리 범위 조절, 거리에 따라 m, km 조정 로직 구현 필요
        sortedBookstores = sortedBookstores.filter { $0.distance < 100 }.sorted { $0.distance < $1.distance }
        
        return Array(sortedBookstores.prefix(3))
    }
    
    // 내 위치의 지역을 문자열로 반환
    private func fetchMyLocation() async throws -> String {
        guard let myLocation = locationManager.location?.coordinate as? CLLocationCoordinate2D else { return "" }
        
        let location = CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        let placemarks = try await geocoder.reverseGeocodeLocation(location, preferredLocale: locale)
        let locality = placemarks.first?.locality ?? ""
        let subLocality = placemarks.first?.subLocality ?? ""
        
        return locality + " " + subLocality
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            return
        case .authorizedWhenInUse, .authorizedAlways:
            model.nearbyBookstores = sortBookstoresByMyLocation(model.bookstores).map { .nearbyBookstore($0) }
            dataSource.apply(snapshot)
            return
        case .restricted, .denied:
            return
        @unknown default:
            return
        }
    }
}
