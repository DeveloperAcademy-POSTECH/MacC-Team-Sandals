//
//  ViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/17.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: Section Definition
    enum Section: Hashable {
        case mainCuration
        case curation
        case nearByBookstore
        case bookmarked
        case region
        case emptyNearby
        case emptyBookmark
    }
    
    private var sections = [Section]()
    
    // MARK: Supplementary View Kind Definition
    enum SupplementaryViewKind {
        static let header = "header"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    // MARK: Snapshot Definition
    var snapshot: NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        snapshot.appendSections([.mainCuration, .curation])
        snapshot.appendItems(Item.mainCuration, toSection: .mainCuration)
        snapshot.appendItems(Item.curations, toSection: .curation)
        
        if Item.nearByBookStores.isEmpty {
            snapshot.appendSections([.emptyNearby])
            snapshot.appendItems([Item.emptyNearby], toSection: .emptyNearby)
        } else {
            snapshot.appendSections([.nearByBookstore])
            snapshot.appendItems([Item.nearByBookStores[0], Item.nearByBookStores[1], Item.nearByBookStores[2]] , toSection: .nearByBookstore)
        }
        
        if Item.bookmarkedBookStores.isEmpty {
            snapshot.appendSections([.emptyBookmark])
            snapshot.appendItems([Item.emptyBookmark], toSection: .emptyBookmark)
        } else {
            snapshot.appendSections([.bookmarked])
            snapshot.appendItems(Item.bookmarkedBookStores, toSection: .bookmarked)
        }
        
        snapshot.appendSections([.region])
        snapshot.appendItems(Item.regions, toSection: .region)
        
        sections = snapshot.sectionIdentifiers
        
        return snapshot
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Navigation Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "circle.fill"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        // MARK: Layout Setup
        collectionView.collectionViewLayout = createLayout()
        
        // MARK: Register
        // Cell Register
        collectionView.register(MainCurationCollectionViewCell.self, forCellWithReuseIdentifier: MainCurationCollectionViewCell.reuseIdentifier)
        collectionView.register(CurationCollectionViewCell.self, forCellWithReuseIdentifier: CurationCollectionViewCell.reuseIdentifier)
        collectionView.register(NearByBookstoreCollectionViewCell.self, forCellWithReuseIdentifier: NearByBookstoreCollectionViewCell.reuseIdentifier)
        collectionView.register(BookmarkedCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkedCollectionViewCell.reuseIdentifier)
        collectionView.register(RegionCollectionViewCell.self, forCellWithReuseIdentifier: RegionCollectionViewCell.reuseIdentifier)
        
        collectionView.register(EmptyNearbyCollectionViewCell.self, forCellWithReuseIdentifier: EmptyNearbyCollectionViewCell.reuseIdentifier)
        collectionView.register(EmptyBookmarkCollectionViewCell.self, forCellWithReuseIdentifier: EmptyBookmarkCollectionViewCell.reuseIdentifier)
        
        // Supplementary View Register
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        
        configureDataSource()
        
        // MARK: Delegate
        collectionView.delegate = self
    }
    
    // MARK: Navigation Item Method
    @objc func searchButtonTapped() {
        let homeSearchViewController = HomeSearchViewController()
        show(homeSearchViewController, sender: nil)
    }
    
    // MARK: Layout Method
    // TODO: 유연하게 수정할 필요있음(반응형으로)
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.sections[sectionIndex]
            
            let padding16: CGFloat = 16
            let padding32: CGFloat = 32
            
            // MARK: Section Header
            let headerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.92),
                heightDimension: .estimated(36)
            )
            let leadingHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: SupplementaryViewKind.header,
                alignment: .topLeading
            )
            let centerHeaderItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: SupplementaryViewKind.header,
                alignment: .top
            )
            
            switch section {
            case .mainCuration:
                // MARK: Main Curation Layout
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .estimated(408)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = NSDirectionalEdgeInsets(top: padding16, leading: 0, bottom: padding32, trailing: 0)
                
                return section
            case .curation:
                // MARK: Curation Section Layout
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: padding16)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(326),
                    heightDimension: .estimated(152)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [leadingHeaderItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: padding16, bottom: padding32, trailing: 0)
                
                return section
            case .nearByBookstore:
                // MARK: Nearby Bookstore Section Layout
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
                section.boundarySupplementaryItems = [centerHeaderItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: padding32, trailing: 0)
                
                return section
            case .bookmarked:
                // MARK: Bookmarked Section Layout
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: padding16)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(136), heightDimension: .estimated(219))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.boundarySupplementaryItems = [leadingHeaderItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: padding16, bottom: padding32, trailing: 0)
                
                return section
            case .region:
                // MARK: Region Section Layout
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
                section.boundarySupplementaryItems = [centerHeaderItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: padding32, trailing: 0)
                
                return section
            case .emptyNearby:
                // MARK: Empty Nearby Section Layout
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(336)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [centerHeaderItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: padding32, trailing: 0)
                
                return section
            case .emptyBookmark:
                // MARK: Empty Bookmark Section Layout
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
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
                section.boundarySupplementaryItems = [centerHeaderItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: padding32, trailing: 0)
                
                return section
            }
        }
        
        return layout
    }
    
    // MARK: Data Source Method
    private func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let section = self.sections[indexPath.section]
            
            switch section {
            case .mainCuration:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCurationCollectionViewCell.reuseIdentifier, for: indexPath) as! MainCurationCollectionViewCell
                cell.configureCell(item.curation!)
                
                return cell
            case .curation:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationCollectionViewCell.reuseIdentifier, for: indexPath) as! CurationCollectionViewCell
                
                let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
                cell.configureCell(item.curation!, indexPath: indexPath, numberOfItems: numberOfItems)
                
                return cell
            case .nearByBookstore:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearByBookstoreCollectionViewCell.reuseIdentifier, for: indexPath) as! NearByBookstoreCollectionViewCell
                cell.configureCell(item.bookStore!)
                
                return cell
            case .bookmarked:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkedCollectionViewCell.reuseIdentifier, for: indexPath) as! BookmarkedCollectionViewCell
                cell.configureCell(item.bookStore!)
                
                return cell
            case .region:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegionCollectionViewCell.reuseIdentifier, for: indexPath) as! RegionCollectionViewCell
                
                let isTopCell = !(indexPath.item < 2)
                let isOddNumber = indexPath.item % 2 == 1
                
                cell.configureCell(item.region!, hideTopLine: isTopCell, hideRightLine: isOddNumber)
                
                return cell
            case .emptyNearby:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyNearbyCollectionViewCell.reuseIdentifier, for: indexPath) as! EmptyNearbyCollectionViewCell
                return cell
            case .emptyBookmark:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyBookmarkCollectionViewCell.reuseIdentifier, for: indexPath) as! EmptyBookmarkCollectionViewCell
                return cell
            }
        }
        
        // MARK: Supplementary View Provider
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case SupplementaryViewKind.header:
                let section = self.sections[indexPath.section]
                let sectionName: String
                let sectionNameColor: UIColor
                let hideSeeAllButton: Bool
                let hideBottomStackView: Bool
                
                switch section {
                case .mainCuration:
                    return nil
                case .curation:
                    sectionName = "킨디터 PICK"
                    sectionNameColor = .systemGreen
                    hideSeeAllButton = true
                    hideBottomStackView = true
                case .nearByBookstore:
                    sectionName = "내 주변 서점"
                    sectionNameColor = .black
                    hideSeeAllButton = false
                    hideBottomStackView = false
                case .bookmarked:
                    sectionName = "북마크 한 서점"
                    sectionNameColor = .black
                    hideSeeAllButton = false
                    hideBottomStackView = true
                case .region:
                    sectionName = "지역별 서점"
                    sectionNameColor = .black
                    hideSeeAllButton = true
                    hideBottomStackView = true
                case .emptyNearby:
                    sectionName = "내 주변 서점"
                    sectionNameColor = .black
                    hideSeeAllButton = false
                    hideBottomStackView = false
                case .emptyBookmark:
                    sectionName = "북마크 한 서점"
                    sectionNameColor = .black
                    hideSeeAllButton = false
                    hideBottomStackView = true
                }
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
                headerView.delegate = self
                headerView.setTitle(sectionName, color: sectionNameColor, hideSeeAllButton: hideSeeAllButton, hideBottomStackView: hideBottomStackView, sectionIndex: indexPath.section)
                
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
        let section = sections[indexPath.section]
        
        switch section {
        case .mainCuration:
            // CurationViewController 대신에 PagingCurationViewController로 바꿔야합니다(변수명도 마찬가지입니다).
            // modalTransitionStyle도 full screen으로 바꿔야합니다.
            // init id? - 어떻게 이어줄지?
            let curationViewController = CurationViewController()
            curationViewController.modalTransitionStyle = .crossDissolve
            present(curationViewController, animated: true)
//        case .curation:
        case .nearByBookstore:
            let detailBookstoreViewController = DetailBookstoreViewController()
            // TODO: 이후 더미데이터 수정
            detailBookstoreViewController.bookstore = Bookstore.dummyData[indexPath.row]
            navigationController?.pushViewController(detailBookstoreViewController, animated: true)
//        case .bookmarked:
        case .region:
            let regionName = Item.regions[indexPath.item].region
            let regionViewController = RegionViewController()
            regionViewController.setupData(regionName: regionName!.name)
            
            show(regionViewController, sender: nil)
        default:
            print("default")
        }
    }
}

// MARK: - Section Header Delegate

extension HomeViewController: SectionHeaderDelegate {
    
    // 다음 뷰컨과 연결할 때 이련 형태로 구현하겠습니다
    func segueWithSectionIndex(_ sectionIndex: Int) {
        
        switch sectionIndex {
        case 2:
            let items = Item.nearByBookStores.map { $0.bookStore! }
            let nearbyViewController = NearbyViewController()
            nearbyViewController.setupData(items: items)
            
            show(nearbyViewController, sender: nil)
        case 3:
            let items = Item.bookmarkedBookStores.map { $0.bookStore! }
            let bookmarkViewController = BookmarkViewController()
            bookmarkViewController.setupData(items: items)
            show(bookmarkViewController, sender: nil)
//        case 4:
//            let regionName = "지역"
//            let regionViewController = RegionViewController()
//            regionViewController.setupData(regionName: regionName)
//
//            show(regionViewController, sender: nil)
        default:
            return
        }
    }
}
