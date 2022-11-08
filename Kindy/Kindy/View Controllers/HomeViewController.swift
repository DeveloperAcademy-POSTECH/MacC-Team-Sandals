//
//  ViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/17.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

final class HomeViewController: UIViewController {
    
    var bookstoresRequestTask: Task<Void, Never>?
    var curationsRequestTask: Task<Void, Never>?
    deinit {
        bookstoresRequestTask?.cancel()
        curationsRequestTask?.cancel()
    }
    
    var model = Model()
    
    enum SupplementaryViewKind {
        static let header = "header"
    }
    
    // MARK: - Collection View
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>!
    
    var snapshot: NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item> {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        snapshot.appendSections([.curation])
        snapshot.appendItems(model.curations)
        
        snapshot.appendSections([.nearby])
        snapshot.appendItems(model.bookstores)
        
        return snapshot
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBarButtonItems()
        
        // MARK: Configure Layout
        collectionView.collectionViewLayout = createLayout()
        
        // MARK: Configure Data Source
        configureDataSource()
        
        // MARK: Delegate
        //        collectionView.delegate = self
        
        // MARK: Registeration
        // Cell Registeration
        collectionView.register(MainCurationCollectionViewCell.self, forCellWithReuseIdentifier: MainCurationCollectionViewCell.identifier)
        collectionView.register(CurationCollectionViewCell.self, forCellWithReuseIdentifier: CurationCollectionViewCell.identifier)
        collectionView.register(NearByBookstoreCollectionViewCell.self, forCellWithReuseIdentifier: NearByBookstoreCollectionViewCell.identifier)
        collectionView.register(BookmarkedCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkedCollectionViewCell.identifier)
        collectionView.register(RegionCollectionViewCell.self, forCellWithReuseIdentifier: RegionCollectionViewCell.identifier)
        collectionView.register(EmptyNearbyCollectionViewCell.self, forCellWithReuseIdentifier: EmptyNearbyCollectionViewCell.identifier)
        collectionView.register(EmptyBookmarkCollectionViewCell.self, forCellWithReuseIdentifier: EmptyBookmarkCollectionViewCell.identifier)
        
        // Supplementary View Registeration
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        update()
        
        // MARK: Nav Bar Appearance
        // 서점 상세화면으로 넘어갔다 오면 상세화면의 네비게이션 바 설정이 적용되기에 재설정 해줬습니다.
        let customNavBarAppearance = UINavigationBarAppearance()
        customNavBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = UIColor(named: "kindyGreen")
        navigationController?.navigationBar.standardAppearance = customNavBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = customNavBarAppearance
        navigationController?.navigationBar.compactAppearance = customNavBarAppearance
        
        // MARK: Tab Bar Appearance
        // 서점 상세화면으로 넘어갔다 오면 상세화면의 탭 바 설정이 적용되기에 재설정 해줬습니다.
        tabBarController?.tabBar.isHidden = false
        
        dataSource.apply(snapshot)
    }
    
    // MARK:  - Navigation Bar
    
    func createBarButtonItems() {
        let scaledImage = UIImage(named: "KindyLogo")?.resizeImage(size: CGSize(width: 80, height: 20)).withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: scaledImage, style: .plain, target: nil, action: nil)
        
        let bellButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(bellButtonTapped))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        
        bellButton.tintColor = .black
        searchButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [bellButton, searchButton]
    }
    
    // 네비게이션 바의 검색 버튼이 눌렸을때 실행되는 함수입니다.
    @objc func searchButtonTapped() {
        let homeSearchViewController = HomeSearchViewController()
        show(homeSearchViewController, sender: nil)
    }
    
    // 네비게이션 바의 종 버튼이 눌렸을때 실행되는 함수입니다.
    @objc func bellButtonTapped() {

    }
    
    // MARK: - Update
    
    func update() {
        curationsRequestTask?.cancel()
        curationsRequestTask = Task {
            if let curations = try? await FirestoreManager().fetchCurations() {
                model.curations = curations
            } else {
                model.curations = []
            }
            dataSource.apply(snapshot)
            
            curationsRequestTask = nil
        }
        
        bookstoresRequestTask?.cancel()
        bookstoresRequestTask = Task {
            if let bookstores = try? await FirestoreManager().fetchBookstores() {
                model.bookstores = bookstores
            } else {
                model.bookstores = []
            }
            dataSource.apply(snapshot)
            
            bookstoresRequestTask = nil
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
            case .curation:
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
                //            case .curation:
                //                let item = NSCollectionLayoutItem(layoutSize: fullSize)
                //                item.contentInsets = leading16ContentInsetsForItem
                //
                //                let groupSize = NSCollectionLayoutSize(
                //                    widthDimension: .estimated(326),
                //                    heightDimension: .estimated(168)
                //                )
                //                let group = NSCollectionLayoutGroup.horizontal(
                //                    layoutSize: groupSize,
                //                    subitems: [item]
                //                )
                //
                //                let section = NSCollectionLayoutSection(group: group)
                //                section.orthogonalScrollingBehavior = .groupPaging
                //                section.boundarySupplementaryItems = [headerItem]
                //                section.contentInsets = sectionContentInsets
                //
                //                return section
            case .nearby:
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
            case .bookmarked:
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
            case .region:
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
//            case .emptyNearby:
//                let item = NSCollectionLayoutItem(layoutSize: fullSize)
//
//                let groupSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .estimated(150)
//                )
//                let group = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: groupSize,
//                    subitem: item,
//                    count: 1
//                )
//
//                let section = NSCollectionLayoutSection(group: group)
//                section.boundarySupplementaryItems = [headerItem]
//                section.contentInsets = sectionContentInsets
//
//                return section
//            case .emptyBookmark:
//                let item = NSCollectionLayoutItem(layoutSize: fullSize)
//
//                let groupSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .estimated(150)
//                )
//                let group = NSCollectionLayoutGroup.horizontal(
//                    layoutSize: groupSize,
//                    subitem: item,
//                    count: 1
//                )
//
//                let section = NSCollectionLayoutSection(group: group)
//                section.boundarySupplementaryItems = [headerItem]
//                section.contentInsets = sectionContentInsets
//
//                return section
            }
        }
        
        return layout
    }
    
    // MARK: - Diffable Data Source Method
    
    // TODO: item 강제 언래핑 대신 더미 넘겨주기
    private func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .curation:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCurationCollectionViewCell.identifier, for: indexPath) as? MainCurationCollectionViewCell else { return UICollectionViewCell() }
                
                cell.configureCell(item.curation!)
                
                return cell
                //            case .curation:
                //                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationCollectionViewCell.identifier, for: indexPath) as? CurationCollectionViewCell else { return UICollectionViewCell() }
                //
                //                let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
                //                cell.configureCell(item.curation!, indexPath: indexPath, numberOfItems: numberOfItems)
                //
                //                return cell
            case .nearby:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByBookstoreCollectionViewCell.identifier, for: indexPath) as? NearByBookstoreCollectionViewCell else { return UICollectionViewCell() }
                cell.configureCell(item.bookstore!)
                
                return cell
            case .bookmarked:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkedCollectionViewCell.identifier, for: indexPath) as? BookmarkedCollectionViewCell else { return UICollectionViewCell() }
                cell.configureCell(item.bookstore!)
                
                return cell
            case .region:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegionCollectionViewCell.identifier, for: indexPath) as? RegionCollectionViewCell else { return UICollectionViewCell() }
                
                let isTopCell = !(indexPath.item < 2)
                let isOddNumber = indexPath.item % 2 == 1
                
                //                cell.configureCell(item.region!, hideTopLine: isTopCell, hideRightLine: isOddNumber)
                
                return cell
            }
        }
        
        // MARK: Supplementary View Provider
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case SupplementaryViewKind.header:
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                let sectionName: String
                let hideSeeAllButton: Bool
                let hideBottomStackView: Bool
                
                switch section {
                case .curation:
                    sectionName = "이런 서점은 어때요"
                    hideSeeAllButton = true
                    hideBottomStackView = true
                    //                case .curation:
                    //                    sectionName = "킨디터 추천 서점"
                    //                    hideSeeAllButton = true
                    //                    hideBottomStackView = true
                case .nearby:
                    sectionName = "내 주변 서점"
                    hideSeeAllButton = false
                    hideBottomStackView = false
                case .bookmarked:
                    sectionName = "북마크 한 서점"
                    hideSeeAllButton = false
                    hideBottomStackView = true
                case .region:
                    sectionName = "지역별 서점"
                    hideSeeAllButton = true
                    hideBottomStackView = true
                }
                
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView else { return UICollectionReusableView() }
                
                //                headerView.delegate = self
                
                headerView.configure(
                    title: sectionName,
                    hideSeeAllButton: hideSeeAllButton,
                    hideBottomStackView: hideBottomStackView,
                    sectionIndex: indexPath.section
                )
                
                return headerView
            default:
                return nil
            }
        }
        
        dataSource.apply(snapshot)
    }
}

// MARK: - Collection View Delegate

//extension HomeViewController: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let section = sections[indexPath.section]
//
//        switch section {
//        case .mainCuration:
//            let curation = Item.mainCuration.map { $0.mainCuration! }.first!
//            let curationViewController = PagingCurationViewController(curation: curation)
//            curationViewController.modalPresentationStyle = .overFullScreen
//            curationViewController.modalTransitionStyle = .crossDissolve
//
//            present(curationViewController, animated: true)
//        case .curation:
//            let curation = Item.curations.map { $0.curation! }[indexPath.item]
//            let curationViewController = PagingCurationViewController(curation: curation)
//            curationViewController.modalPresentationStyle = .overFullScreen
//            curationViewController.modalTransitionStyle = .crossDissolve
//
//            present(curationViewController, animated: true)
//        case .nearby:
//            let bookstore = Item.nearByBookStores.map { $0.bookstore! }[indexPath.item]
//            let detailBookstoreViewController = DetailBookstoreViewController()
//            detailBookstoreViewController.bookstore = bookstore
//
//            navigationController?.pushViewController(detailBookstoreViewController, animated: true)
//        case .bookmarked:
//            let bookstore = Item.bookmarkedBookStores.map { $0.bookstore! }[indexPath.item]
//            let detailBookstoreViewController = DetailBookstoreViewController()
//            detailBookstoreViewController.bookstore = bookstore
//
//            navigationController?.pushViewController(detailBookstoreViewController, animated: true)
//        case .region:
//            let regionName = Item.regions[indexPath.item].region!.name
//            let regionViewController = RegionViewController()
//            regionViewController.setupData(regionName: regionName)
//
//            show(regionViewController, sender: nil)
//        default:
//            return
//        }
//    }
//}

// MARK: - Section Header Delegate

// TODO: 0번째 섹션 추가해야함
//extension HomeViewController: SectionHeaderDelegate {
//
//    func segueWithSectionIndex(_ sectionIndex: Int) {
//        switch sectionIndex {
//        case 2:
//            let items = Item.nearByBookStores.map { $0.bookstore! }
//            let nearbyViewController = NearbyViewController()
//            nearbyViewController.setupData(items: items)
//            show(nearbyViewController, sender: nil)
//        case 3:
//            let items = Item.bookmarkedBookStores.map { $0.bookstore! }
//            let bookmarkViewController = BookmarkViewController()
//            bookmarkViewController.setupData(items: items)
//            show(bookmarkViewController, sender: nil)
//        default:
//            return
//        }
//    }
//}


// MARK: Scroll View Delegate

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (velocity.y > 0) {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
}
