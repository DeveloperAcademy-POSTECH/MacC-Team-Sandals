//
//  BookmarkViewController.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/10/23.
//

import UIKit

final class BookmarkViewController: UIViewController {
    
    enum Section: Hashable {
        case bookmark
    }
    
    var totalData: [Bookstore] = []

    private var filterdItem = [Bookstore]()
    
    private let searchController = UISearchController()
    
    private lazy var bookMarkCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Bookstore>!
    
    private var filteredItemSnapshot: NSDiffableDataSourceSnapshot<Section, Bookstore> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Bookstore>()
        snapshot.appendSections([.bookmark])
        snapshot.appendItems(filterdItem)
        return snapshot
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "북마크"
        self.navigationController?.navigationBar.barTintColor = .white
        setupSearchController()
        setupCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        // MARK: Navigation Bar Appearance
        // 서점 상세화면으로 넘어갔다 오면 상세화면의 네비게이션 바 설정이 적용되기에 재설정 해줬습니다.
        let customNavBarAppearance = UINavigationBarAppearance()
        customNavBarAppearance.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = UIColor(named: "kindyGreen")
        navigationController?.navigationBar.standardAppearance = customNavBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = customNavBarAppearance
        navigationController?.navigationBar.compactAppearance = customNavBarAppearance
    }
    
    // 서치컨트롤러 설정
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // 컬렉션뷰 설정
    private func setupCollectionView() {
        view.addSubview(bookMarkCollectionView)
        bookMarkCollectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.identifier)
        bookMarkCollectionView.setCollectionViewLayout(createLayout(), animated: false)
        bookMarkCollectionView.showsVerticalScrollIndicator = false
        bookMarkCollectionView.frame = view.bounds
    }
    
    func setupData(items: [Bookstore]) {
        totalData = items
        filterdItem = items
    }
    
    // CollectionView layout 지정
    func createLayout() -> UICollectionViewLayout {
        // fractionalSize -> Group과 아이템의 비율
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let spacing: CGFloat = 0

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5545))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: spacing)
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: 추후 데이터 전달 타입 변경 필요
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: bookMarkCollectionView) {  collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.identifier, for: indexPath) as? BookmarkCollectionViewCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.configureCell(itemIdentifier, indexPath.row)
            cell.configureCarouselView()
            return cell
        }
        dataSource.apply(filteredItemSnapshot)
    }

}


extension BookmarkViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let findString = searchController.searchBar.text, !findString.isEmpty {
            filterdItem = totalData.filter{ $0.name.lowercased().contains(findString.lowercased()) }
        } else {
            filterdItem = totalData
        }
        dataSource.apply(filteredItemSnapshot, animatingDifferences: true)
    }
}
// MARK: 추후 Bookmark 삭제로직 구현 예정
extension BookmarkViewController: BookmarkDelegate {
    func deleteBookmark(_ deleteItem: Bookstore) {
        filterdItem = filterdItem.filter{ $0.id != deleteItem.id }
        NewItems.bookmarkToggle(deleteItem)
        totalData = NewItems.bookstoreDummy.filter{ $0.isFavorite }
        
        dataSource.apply(filteredItemSnapshot, animatingDifferences: true)
    }
    
    
    func selectItem(_ bookstore: Bookstore) {
        let detailBookstoreViewController = DetailBookstoreViewController()
        detailBookstoreViewController.bookstore = bookstore
        navigationController?.pushViewController(detailBookstoreViewController, animated: true)
    }
}
