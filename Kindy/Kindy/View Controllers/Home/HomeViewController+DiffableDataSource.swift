import UIKit

extension HomeViewController {
    func configureDataSource() {
        // MARK: Cell registration
        let curationCellRegistration = UICollectionView.CellRegistration<CurationCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.curation ?? Curation.error)

            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.curation?.mainImage) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
        }

        let bookstoreCellRegistration = UICollectionView.CellRegistration<FeaturedBookstoreCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
        }

        let nearbyBookstoreCellRegistration = UICollectionView.CellRegistration<NearByBookstoreCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
        }

        let bookmarkedBookstoreCellRegistration = UICollectionView.CellRegistration<BookmarkedBookstoreCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
        }

        let regionNameCellRegistration = UICollectionView.CellRegistration<RegionNameCell, ViewModel.Item> { cell, indexPath, item in
            let isTopCell = !(indexPath.item < 2)
            let isOddNumber = indexPath.item % 2 == 1

            cell.configureCell(item.region!, hideTopLine: isTopCell, hideRightLine: isOddNumber)
        }

        let emptyNearbyCellRegistration = UICollectionView.CellRegistration<EmptyNearbyCell, ViewModel.Item> { _, _, _ in }

        let noPermissionCellRegistration = UICollectionView.CellRegistration<NoPermissionCell, ViewModel.Item> { _, _, _ in }

        let exceptionBookmarkCellRegistration = UICollectionView.CellRegistration<ExceptionBookmarkCell, ViewModel.Item> { cell, _, _ in
            cell.label.text = UserManager().isLoggedIn() ? "북마크한 서점이 아직 없어요" : "로그인 후 이용할 수 있는 서비스입니다."
        }

        // MARK: Supplementary view registration
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(elementKind: SupplementaryViewKind.header) { headerView, _, indexPath in

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
            case .nearbys, .emptyNearbys, .noPermission:
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

        // MARK: Data source initialization
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
            case .emptyNearbys:
                return collectionView.dequeueConfiguredReusableCell(using: emptyNearbyCellRegistration, for: indexPath, item: item)
            case .noPermission:
                return collectionView.dequeueConfiguredReusableCell(using: noPermissionCellRegistration, for: indexPath, item: item)
            case .emptyBookmarks:
                return collectionView.dequeueConfiguredReusableCell(using: exceptionBookmarkCellRegistration, for: indexPath, item: item)
            }
        }

        // MARK: Supplementary view provider
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }

        dataSource.apply(snapshot)
    }
}
