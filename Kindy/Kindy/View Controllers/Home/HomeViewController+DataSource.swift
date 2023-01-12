import UIKit

import Kingfisher

extension HomeViewController {
    func configureDataSource() {
        typealias CellRegistration = UICollectionView.CellRegistration
        typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration

        // MARK: Cell registration
        let curationCell = CellRegistration<CurationCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.curation ?? Curation.error)

            let url = URL(string: item.curation?.mainImage ?? "")
            let processor = DownsamplingImageProcessor(size: ImageSize.large)
            cell.imageView.kf.indicatorType = .activity

            cell.imageView.kf.setImage(
                with: url,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(2)),
                    .cacheOriginalImage
                ]
            ) {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }

//            self.imagesTask = Task {
//                if let image = try? await ImageCache.shared.load(item.curation?.mainImage) {
//                    cell.imageView.image = image
//                }
//                self.imagesTask = nil
//            }
        }

        let bookstoreCell = CellRegistration<FeaturedBookstoreCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
        }

        let nearbyBookstoreCell = CellRegistration<NearByBookstoreCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
        }

        let bookmarkedBookstoreCell = CellRegistration<BookmarkedBookstoreCell, ViewModel.Item> { cell, _, item in
            cell.configureCell(item.bookstore ?? Bookstore.error)

            self.imagesTask = Task {
                if let image = try? await ImageCache.shared.load(item.bookstore?.images?.first) {
                    cell.imageView.image = image
                }
                self.imagesTask = nil
            }
        }

        let regionNameCell = CellRegistration<RegionNameCell, ViewModel.Item> { cell, indexPath, item in
            let isTopCell = !(indexPath.item < 2)
            let isOddNumber = indexPath.item % 2 == 1

            cell.configureCell(item.region, hideTopLine: isTopCell, hideRightLine: isOddNumber)
        }

        let emptyNearbyCell = CellRegistration<EmptyNearbyCell, ViewModel.Item> { _, _, _ in }

        let noPermissionCell = CellRegistration<NoPermissionCell, ViewModel.Item> { _, _, _ in }

        let exceptionBookmarkCell = CellRegistration<ExceptionBookmarkCell, ViewModel.Item> { cell, _, _ in
            cell.label.text = UserManager().isLoggedIn() ? "북마크한 서점이 아직 없어요" : "로그인 후 이용할 수 있는 서비스입니다."
        }

        // MARK: Supplementary view registration
        let header = SupplementaryRegistration<SectionHeader>(elementKind: SupplementaryView.headerKind) { header, _, indexPath in
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

        // MARK: Data source initialization
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch section {
            case .curations:
                return collectionView.dequeueConfiguredReusableCell(
                    using: curationCell,
                    for: indexPath,
                    item: item
                )
            case .featured:
                return collectionView.dequeueConfiguredReusableCell(
                    using: bookstoreCell,
                    for: indexPath,
                    item: item
                )
            case .nearbys:
                return collectionView.dequeueConfiguredReusableCell(
                    using: nearbyBookstoreCell,
                    for: indexPath,
                    item: item
                )
            case .bookmarks:
                return collectionView.dequeueConfiguredReusableCell(
                    using: bookmarkedBookstoreCell,
                    for: indexPath,
                    item: item
                )
            case .regions:
                return collectionView.dequeueConfiguredReusableCell(
                    using: regionNameCell,
                    for: indexPath,
                    item: item
                )
            case .emptyNearbys:
                return collectionView.dequeueConfiguredReusableCell(
                    using: emptyNearbyCell,
                    for: indexPath,
                    item: item
                )
            case .noPermission:
                return collectionView.dequeueConfiguredReusableCell(
                    using: noPermissionCell,
                    for: indexPath,
                    item: item
                )
            case .emptyBookmarks:
                return collectionView.dequeueConfiguredReusableCell(
                    using: exceptionBookmarkCell,
                    for: indexPath,
                    item: item
                )
            }
        }

        // MARK: Supplementary view provider
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: header, for: indexPath)
        }

        dataSource.apply(snapshot)
    }
}
