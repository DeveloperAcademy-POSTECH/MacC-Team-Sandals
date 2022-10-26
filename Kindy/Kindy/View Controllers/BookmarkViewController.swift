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
    
//    var dummyData: [Bookstore] = [
//        Bookstore(images: nil, name: "달팽이 책방1", address: "포항시 남구", telNumber: "020202020", emailAddress: "ㅁㄴㅇㄹㅁㄴㅇㄹ", instagramURL: nil, businessHour: "ㅁㄴㅇㄹㅁㄴㅇㄹ", description: "ㅁㄴㅇㄹㅁㄴㅇㄹ", location: Location(latitude: 10, longitude: 10)),
//        Bookstore(images: nil, name: "달팽이 책방2", address: "포항시 남구", telNumber: "020202020", emailAddress: "ㅁㄴㅇㄹㅁㄴㅇㄹ", instagramURL: nil, businessHour: "ㅁㄴㅇㄹㅁㄴㅇㄹ", description: "ㅁㄴㅇㄹㅁㄴㅇㄹ", location: Location(latitude: 10, longitude: 10)),
//        Bookstore(images: nil, name: "달팽이 책방3", address: "포항시 남구", telNumber: "020202020", emailAddress: "ㅁㄴㅇㄹㅁㄴㅇㄹ", instagramURL: nil, businessHour: "ㅁㄴㅇㄹㅁㄴㅇㄹ", description: "ㅁㄴㅇㄹㅁㄴㅇㄹ", location: Location(latitude: 10, longitude: 10)),
//        Bookstore(images: nil, name: "달팽이 책방4", address: "포항시 남구", telNumber: "020202020", emailAddress: "ㅁㄴㅇㄹㅁㄴㅇㄹ", instagramURL: nil, businessHour: "ㅁㄴㅇㄹㅁㄴㅇㄹ", description: "ㅁㄴㅇㄹㅁㄴㅇㄹ", location: Location(latitude: 10, longitude: 10)),
//        Bookstore(images: nil, name: "달팽이 책방5", address: "포항시 남구", telNumber: "020202020", emailAddress: "ㅁㄴㅇㄹㅁㄴㅇㄹ", instagramURL: nil, businessHour: "ㅁㄴㅇㄹㅁㄴㅇㄹ", description: "ㅁㄴㅇㄹㅁㄴㅇㄹ", location: Location(latitude: 10, longitude: 10))
//    ]
    
    private var filterdItem = [Bookstore]()
    
    private let searchController = UISearchController()
    
    private lazy var bookMarkCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Bookstore>!
    
    private var filteredItemSanpshot: NSDiffableDataSourceSnapshot<Section, Bookstore> = {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Bookstore>()
        return snapshot
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "북마크"
        self.navigationController?.navigationBar.barTintColor = .white
        setupSearchController()
        setupCollectionView()
        configureDataSource()
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
//        dummyData = items
        filterdItem = items
        filteredItemSanpshot.appendSections([.bookmark])
        filteredItemSanpshot.appendItems(filterdItem)
    }
    
    // CollectionView layout 지정
    func createLayout() -> UICollectionViewLayout {
        // fractionalSize -> Group과 아이템의 비율
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let spacing: CGFloat = 0

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5545))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
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
            cell.configureCarouselView(with: ["testImage", "testImage"])
            return cell
        }
        dataSource.apply(filteredItemSanpshot)
    }

}


extension BookmarkViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let findString = searchController.searchBar.text, !findString.isEmpty {
            print("heheheheheh\(findString)")
            filterdItem = filteredItemSanpshot.itemIdentifiers.filter{ $0.name.lowercased().contains(findString.lowercased()) }
        } else {
            filterdItem = filteredItemSanpshot.itemIdentifiers
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Bookstore>()
        snapshot.appendSections([.bookmark])
        snapshot.appendItems(filterdItem)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
// MARK: 추후 Bookmark 삭제로직 구현 예정
extension BookmarkViewController: BookmarkDelegate {
    func deleteBookmark(_ deleteItem: Bookstore) {
        var snapshot = filteredItemSanpshot
        snapshot.deleteItems([deleteItem])
//        dummyData = snapshot.itemIdentifiers
        filteredItemSanpshot = snapshot
        if let findString = searchController.searchBar.text, !findString.isEmpty {
            print("heheheheheh\(findString)")
            filterdItem = filteredItemSanpshot.itemIdentifiers.filter{ $0.name.lowercased().contains(findString.lowercased()) }
        } else {
            filterdItem = filteredItemSanpshot.itemIdentifiers
        }
        var filteredsnapshot = NSDiffableDataSourceSnapshot<Section, Bookstore>()
        filteredsnapshot.appendSections([.bookmark])
        filteredsnapshot.appendItems(filterdItem)
        
        
        dataSource.apply(filteredsnapshot, animatingDifferences: true)
    }
    
    
    func selectItem(_ bookstore: Bookstore) {
        let detailBookstoreViewController = DetailBookstoreViewController()
        detailBookstoreViewController.bookstore = bookstore
        navigationController?.pushViewController(detailBookstoreViewController, animated: true)
    }
}
