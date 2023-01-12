import UIKit

// MARK: Registration
extension HomeViewController {
    typealias CellRegistration = UICollectionView.CellRegistration
    typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration

    func curationCellRegistration() -> CellRegistration<CurationCell, ViewModel.Item> {
        CellRegistration<CurationCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.curation ?? Curation.error)

            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.curation?.mainImage) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
        }
    }

    func bookstoreCellRegistration() -> CellRegistration<FeaturedBookstoreCell, ViewModel.Item> {
        CellRegistration<FeaturedBookstoreCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
        }
    }

    func nearbyBookstoreCellRegistration() -> CellRegistration<NearByBookstoreCell, ViewModel.Item> {
        CellRegistration<NearByBookstoreCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
        }
    }

    func bookmarkedBookstoreCellRegistration() -> CellRegistration<BookmarkedBookstoreCell, ViewModel.Item> {
        CellRegistration<BookmarkedBookstoreCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
        }
    }

    func regionNameCellRegistration() -> CellRegistration<RegionNameCell, ViewModel.Item> {
        CellRegistration<RegionNameCell, ViewModel.Item> { cell, indexPath, item in
            let isTopCell = !(indexPath.item < 2)
            let isOddNumber = indexPath.item % 2 == 1

            cell.configureCell(item.region, hideTopLine: isTopCell, hideRightLine: isOddNumber)
        }
    }

    func emptyNearbyCellRegistration() -> CellRegistration<EmptyNearbyCell, ViewModel.Item> {
        CellRegistration<EmptyNearbyCell, ViewModel.Item> { _, _, _ in }
    }

    func noPermissionCellRegistration() -> CellRegistration<NoPermissionCell, ViewModel.Item> {
        CellRegistration<NoPermissionCell, ViewModel.Item> { _, _, _ in }
    }

    func exceptionBookmarkCellRegistration() -> CellRegistration<ExceptionBookmarkCell, ViewModel.Item> {
        CellRegistration<ExceptionBookmarkCell, ViewModel.Item> { cell, _, _ in
            cell.label.text = UserManager().isLoggedIn() ? "북마크한 서점이 아직 없어요" : "로그인 후 이용할 수 있는 서비스입니다."
        }
    }

    func headerRegistration() -> SupplementaryRegistration<SectionHeader> {
        SupplementaryRegistration<SectionHeader>(elementKind: SupplementaryView.headerKind)
        {
            header, _, indexPath in
            header.delegate = self

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
                    try await header.regionLabel.text = self.fetchMyLocation()
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

            header.configure(
                title: sectionName,
                hideSeeAllButton: hideSeeAllButton,
                hideBottomStackView: hideBottomStackView,
                sectionIndex: indexPath.section
            )
        }
    }
}

// MARK: Data source initialization
extension HomeViewController {
    func configureDataSource() {
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch section {
            case .curations:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.curationCellRegistration(),
                    for: indexPath,
                    item: item
                )
            case .featured:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.bookstoreCellRegistration(),
                    for: indexPath,
                    item: item
                )
            case .nearbys:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.nearbyBookstoreCellRegistration(),
                    for: indexPath,
                    item: item
                )
            case .bookmarks:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.bookmarkedBookstoreCellRegistration(),
                    for: indexPath,
                    item: item
                )
            case .regions:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.regionNameCellRegistration(),
                    for: indexPath,
                    item: item
                )
            case .emptyNearbys:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.emptyNearbyCellRegistration(),
                    for: indexPath,
                    item: item
                )
            case .noPermission:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.noPermissionCellRegistration(),
                    for: indexPath,
                    item: item
                )
            case .emptyBookmarks:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.exceptionBookmarkCellRegistration(),
                    for: indexPath,
                    item: item
                )
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: self.headerRegistration(),
                for: indexPath
            )
        }

        dataSource.apply(snapshot)
    }
}
