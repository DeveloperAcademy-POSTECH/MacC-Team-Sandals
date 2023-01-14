import UIKit

import Kingfisher

extension HomeViewController {
    // MARK: Cell registrations
    func registerCells() {
        registerCurationCell()
        registerFeaturedBookstoreCell()
        registerNearbyBookstoreCell()
        registerBookmarkedBookstoreCell()
        registerRegionNameCell()
        registerExceptionCells()
    }

    func registerCurationCell() {
        curationCellRegistration = .init { cell, _, item in
            cell.configureCell(item.curation ?? Curation.error)

            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(
                with: URL(string: item.curation?.mainImage ?? ""),
                options: [
                    .processor(DownsamplingImageProcessor(size: ImageSize.large)),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.5)),
                    .cacheOriginalImage
                ]
            )
        }
    }

    func registerFeaturedBookstoreCell() {
        featuredBookstoreCellRegistration = .init { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(
                with: URL(string: item.bookstore?.images?.first ?? ""),
                options: [
                    .processor(DownsamplingImageProcessor(size: ImageSize.medium)),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.5)),
                    .cacheOriginalImage
                ]
            )
        }
    }

    func registerNearbyBookstoreCell() {
        nearbyBookstoreCellRegistration = .init { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(
                with: URL(string: item.bookstore?.images?.first ?? ""),
                options: [
                    .processor(DownsamplingImageProcessor(size: ImageSize.small)),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.5)),
                    .cacheOriginalImage
                ]
            )
        }
    }

    func registerBookmarkedBookstoreCell() {
        bookmarkedBookstoreCellRegistration = .init { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(
                with: URL(string: item.bookstore?.images?.first ?? ""),
                options: [
                    .processor(DownsamplingImageProcessor(size: ImageSize.medium)),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.5)),
                    .cacheOriginalImage
                ]
            )
        }
    }

    func registerRegionNameCell() {
        regionNameCellRegistration = .init { cell, indexPath, item in
            let isTopCell = !(indexPath.item < 2)
            let isOddNumber = indexPath.item % 2 == 1

            cell.configureCell(item.region, hideTopLine: isTopCell, hideRightLine: isOddNumber)
        }
    }

    func registerExceptionCells() {
        emptyNearbyCellRegistration = .init { _, _, _ in }
        noPermissionCellRegistration = .init { _, _, _ in }
        exceptionBookmarkCellRegistration = .init { cell, _, _ in
            cell.label.text = UserManager().isLoggedIn() ? "북마크한 서점이 아직 없어요" : "로그인 후 이용할 수 있는 서비스입니다."
        }
    }

    // MARK: Header registration
    func registerHeaderView() {
        headerRegistration = .init(elementKind: SupplementaryView.headerKind) { header, _, indexPath in
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

// MARK: Configure datasource
extension HomeViewController {
    func configureDataSource() {
        registerCells()
        registerHeaderView()

        // MARK: Data source initialization
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch section {
            case .curations:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.curationCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .featured:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.featuredBookstoreCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .nearbys:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.nearbyBookstoreCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .bookmarks:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.bookmarkedBookstoreCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .regions:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.regionNameCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .emptyNearbys:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.emptyNearbyCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .noPermission:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.noPermissionCellRegistration,
                    for: indexPath,
                    item: item
                )
            case .emptyBookmarks:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.exceptionBookmarkCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }

        // MARK: Supplementary view provider
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(
                using: self.headerRegistration,
                for: indexPath
            )
        }

        dataSource.apply(snapshot)
    }
}
