//
//  ViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/17.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: Section
    enum Section: Hashable {
        case mainCuration
        case curation
        case nearByBookstore
        case bookmarked
        case region
    }
    
    // MARK: Collection View
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Diffable Data Source
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var sections = [Section]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Configure Data Source
    func configureDataSource() {
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
                cell.configureCell(item.curation!, index: indexPath)
                
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
                
                // TODO: Line 로직 구현
                cell.configureCell(item.region!, hideTopLine: false, hideRightLine: false)
                
                return cell
            }
        }
        
        // MARK: Snapshot Definition
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.mainCuration, .curation, .nearByBookstore, .bookmarked, .region])
        snapshot.appendItems(Item.curations, toSection: .mainCuration)
        snapshot.appendItems(Item.curations, toSection: .curation)
        snapshot.appendItems(Item.nearByBookStores, toSection: .nearByBookstore)
        snapshot.appendItems(Item.bookmarkedBookStores, toSection: .bookmarked)
        snapshot.appendItems(Item.regions, toSection: .region)
    }
}

