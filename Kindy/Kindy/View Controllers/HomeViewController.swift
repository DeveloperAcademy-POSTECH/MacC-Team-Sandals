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
    private var bookstoresRequestTask: Task<Void, Never>?
    private var curationsRequestTask: Task<Void, Never>?
    private var bookmarkedBookstoresRequestTask: Task<Void, Never>?
    private var imageRequestTask: Task<Void, Never>?
    
    deinit {
        bookstoresRequestTask?.cancel()
        curationsRequestTask?.cancel()
        imageRequestTask?.cancel()
        bookmarkedBookstoresRequestTask?.cancel()
    }
    
    // MARK: Managers
    private let firestoreManager = FirestoreManager()
    private let locationManager = CLLocationManager()
    
    private var model = Model()
    private var bookstores: [Bookstore] = []
    
    enum SupplementaryViewKind {
        static let header = "header"
    }
    
    // MARK: - Collection View
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>!
    
    private var snapshot: NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item> {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        snapshot.appendSections([.curations])
        snapshot.appendItems(model.curations)
        
        snapshot.appendSections([.bookstores])
        snapshot.appendItems(model.featuredBookstores)
        
        switch locationManager.authorizationStatus {
        case .notDetermined, .denied, .restricted:
            snapshot.appendSections([.noPermission])
            snapshot.appendItems([.noPermission])
        default:
            snapshot.appendSections([.nearbys])
            snapshot.appendItems(model.bookstores)
        }
        
        if model.bookmarkedBookstores.isEmpty || !firestoreManager.isLoggedIn() {
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
        
        // MARK: Registerations
        // Cell Registeration
        collectionView.register(CurationCollectionViewCell.self, forCellWithReuseIdentifier: CurationCollectionViewCell.identifier)
        collectionView.register(BookstoreCollectionViewCell.self, forCellWithReuseIdentifier: BookstoreCollectionViewCell.identifier)
        collectionView.register(NearByBookstoreCollectionViewCell.self, forCellWithReuseIdentifier: NearByBookstoreCollectionViewCell.identifier)
        collectionView.register(BookmarkedCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkedCollectionViewCell.identifier)
        collectionView.register(RegionCollectionViewCell.self, forCellWithReuseIdentifier: RegionCollectionViewCell.identifier)
        collectionView.register(EmptyNearbyCollectionViewCell.self, forCellWithReuseIdentifier: EmptyNearbyCollectionViewCell.identifier)
        collectionView.register(ExceptionBookmarkCollectionViewCell.self, forCellWithReuseIdentifier: ExceptionBookmarkCollectionViewCell.identifier)
        collectionView.register(NoPermissionCollectionViewCell.self, forCellWithReuseIdentifier: NoPermissionCollectionViewCell.identifier)
        
        // Supplementary View Registeration
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.identifier)
        
        // MARK: Location Manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        curationsRequestTask?.cancel()
        bookstoresRequestTask?.cancel()
        imageRequestTask?.cancel()
        bookmarkedBookstoresRequestTask?.cancel()
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
        let homeSearchViewController = HomeSearchViewController()
        // MARK : add by X
        homeSearchViewController.setupData(items: self.bookstores)
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
        curationsRequestTask?.cancel()
        curationsRequestTask = Task {
            if let curations = try? await firestoreManager.fetchCurations() {
                model.curations = curations.map { .curation($0) }
            } else {
                model.curations = []
            }
            dataSource.apply(snapshot)
            
            curationsRequestTask = nil
        }
        
        bookstoresRequestTask?.cancel()
        bookstoresRequestTask = Task {
            if var bookstores = try? await firestoreManager.fetchBookstores() {
                // 전체 데이터에 추가
                self.bookstores = bookstores
                
                switch locationManager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    model.bookstores = sortBookstoresByMyLocation(bookstores).map { .nearbyBookstore($0) }
                default:
                    model.bookstores = bookstores.map { .nearbyBookstore($0) }
                }
                
                // TODO: 지금은 전체 데이터 수가 3개라 2개만 제거했지만 많아지면 반복문으로 교체(랜덤 로직도 추가)
                model.featuredBookstores = [bookstores.removeLast(), bookstores.removeLast()].map { .featuredBookstore($0) }
            } else {
                model.bookstores = []
                model.featuredBookstores = []
            }
            dataSource.apply(snapshot)
            
            bookstoresRequestTask = nil
        }
        
        bookmarkedBookstoresRequestTask?.cancel()
        bookmarkedBookstoresRequestTask = Task {
            if let bookmarkedBookstores = try? await firestoreManager.fetchBookmarkedBookstores() {
                model.bookmarkedBookstores = bookmarkedBookstores.map { .bookmarkedBookstore($0) }
            } else {
                model.bookmarkedBookstores = []
            }
            dataSource.apply(snapshot)

            bookmarkedBookstoresRequestTask = nil
        }
    }
    
    // MARK: - Compositional Layout Method
    
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
            case .bookstores:
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
    
    // MARK: - Diffable Data Source Method
    
    private func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView) { [self] collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .curations:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationCollectionViewCell.identifier, for: indexPath) as? CurationCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureCell(item.curation!)
                
                self.imageRequestTask = Task {
                    if let image = try? await firestoreManager.fetchImage(with: item.curation?.descriptions[indexPath.item].image) {
                        cell.imageView.image = image
                    }
                    imageRequestTask = nil
                }
                
                return cell
            case .bookstores:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookstoreCollectionViewCell.identifier, for: indexPath) as? BookstoreCollectionViewCell else { return UICollectionViewCell() }
                
                let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
                cell.configureCell(item.bookstore!, indexPath: indexPath, numberOfItems: numberOfItems)
                
                self.imageRequestTask = Task {
                    if let image = try? await firestoreManager.fetchImage(with: item.bookstore?.images?.first!) {
                        cell.imageView.image = image
                    }
                    imageRequestTask = nil
                }
                
                return cell
            case .nearbys:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByBookstoreCollectionViewCell.identifier, for: indexPath) as? NearByBookstoreCollectionViewCell else { return UICollectionViewCell() }
                cell.configureCell(item.bookstore!)
                
                self.imageRequestTask = Task {
                    if let image = try? await firestoreManager.fetchImage(with: item.bookstore?.images?.first!) {
                        cell.imageView.image = image
                    }
                    imageRequestTask = nil
                }
                
                return cell
            case .bookmarks:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkedCollectionViewCell.identifier, for: indexPath) as? BookmarkedCollectionViewCell else { return UICollectionViewCell() }
                cell.configureCell(item.bookstore!)
                
                self.imageRequestTask = Task {
                    if let image = try? await firestoreManager.fetchImage(with: item.bookstore?.images?.first!) {
                        cell.imageView.image = image
                    }
                    imageRequestTask = nil
                }
                
                return cell
            case .regions:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegionCollectionViewCell.identifier, for: indexPath) as? RegionCollectionViewCell else { return UICollectionViewCell() }
                
                let isTopCell = !(indexPath.item < 2)
                let isOddNumber = indexPath.item % 2 == 1
                
                cell.configureCell(item.region!, hideTopLine: isTopCell, hideRightLine: isOddNumber)
                
                return cell
            case .noPermission:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoPermissionCollectionViewCell.identifier, for: indexPath) as? NoPermissionCollectionViewCell else { return UICollectionViewCell() }
                
                return cell
            case .emptyBookmarks:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExceptionBookmarkCollectionViewCell.identifier, for: indexPath) as? ExceptionBookmarkCollectionViewCell else { return UICollectionViewCell() }
                cell.label.text = firestoreManager.isLoggedIn() ? "북마크한 서점이 아직 없어요" : "로그인 후 이용할 수 있는 서비스입니다."
                return cell
            }
        }
        
        // MARK: Supplementary View Provider
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView else { return UICollectionReusableView() }
            
            headerView.delegate = self
            
            switch kind {
            case SupplementaryViewKind.header:
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                let sectionName: String
                let hideSeeAllButton: Bool
                let hideBottomStackView: Bool
                
                switch section {
                case .curations:
                    sectionName = "킨디터 Pick"
                    hideSeeAllButton = true
                    hideBottomStackView = true
                case .bookstores:
                    sectionName = "이런 서점은 어때요"
                    hideSeeAllButton = true
                    hideBottomStackView = true
                case .nearbys, .noPermission:
                    sectionName = "내 주변 서점"
                    hideSeeAllButton = false
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
                
                return headerView
            default:
                return nil
            }
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
            let curation = model.curations.map { $0.curation! }.first!
            let curationViewController = PagingCurationViewController(curation: curation)
            curationViewController.modalPresentationStyle = .overFullScreen
            curationViewController.modalTransitionStyle = .crossDissolve
            
            present(curationViewController, animated: true)
        case .bookstores:
            let featuredBookstore = model.featuredBookstores.map { $0.bookstore! }
            let detailBookstoreViewController = DetailBookstoreViewController()
            detailBookstoreViewController.bookstore = featuredBookstore[indexPath.item]
            
            navigationController?.pushViewController(detailBookstoreViewController, animated: true)
        case .nearbys:
            let bookstore = model.bookstores.map { $0.bookstore! }
            let detailBookstoreViewController = DetailBookstoreViewController()
            detailBookstoreViewController.bookstore = bookstore[indexPath.item]
            
            navigationController?.pushViewController(detailBookstoreViewController, animated: true)
        case .bookmarks:
            let bookmarkedBookstores = model.bookmarkedBookstores.map { $0.bookstore! }
            let detailBookstoreViewController = DetailBookstoreViewController()
            detailBookstoreViewController.bookstore = bookmarkedBookstores[indexPath.item]

            navigationController?.pushViewController(detailBookstoreViewController, animated: true)
        case .regions:
            let model = model.regions[indexPath.item]
            let regionViewController = RegionViewController()
            regionViewController.setupData(regionName: model.region!, items: self.bookstores)

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
            let nearbyBookstores = model.bookstores.map { $0.bookstore! }
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
            model.bookstores = sortBookstoresByMyLocation(model.bookstores.map { $0.bookstore! }).map { .nearbyBookstore($0) }
            dataSource.apply(snapshot)
            return
        case .restricted, .denied:
            return
        @unknown default:
            return
        }
    }
}
