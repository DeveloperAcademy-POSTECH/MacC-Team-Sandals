import UIKit

enum SupplementaryView {
    static let headerKind = "header"

    static let header = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: Size.header,
        elementKind: headerKind,
        alignment: .top
    )
}

// MARK: Configures each section
extension HomeViewController {
    func configureCurationSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: Size.full)

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
        section.boundarySupplementaryItems = [SupplementaryView.header]
        section.contentInsets = Inset.topBottomEight

        return section
    }

    func configureFeaturedSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: Size.full)
        item.contentInsets = Inset.leadingSixteen

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
        section.boundarySupplementaryItems = [SupplementaryView.header]
        section.contentInsets = Inset.topBottomEight

        return section
    }

    func configureNearbySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.3)
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
        section.boundarySupplementaryItems = [SupplementaryView.header]
        section.contentInsets = Inset.topBottomEight

        return section
    }

    func configureBookmarkSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: Size.full)
        item.contentInsets = Inset.leadingSixteen

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .estimated(219)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.boundarySupplementaryItems = [SupplementaryView.header]
        section.contentInsets = Inset.topBottomEight

        return section
    }

    func configureRegionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
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
        section.boundarySupplementaryItems = [SupplementaryView.header]
        section.contentInsets = Inset.topBottomEight

        return section
    }

    func configureExceptionSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: Size.full)

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
        section.boundarySupplementaryItems = [SupplementaryView.header]
        section.contentInsets = Inset.topBottomEight

        return section
    }

    func configureHeader() {
        SupplementaryView.header.contentInsets = Inset.topBottomSixteen
    }
}

// MARK: Configure layout
extension HomeViewController {
    func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]

            self.configureHeader()

            switch section {
            case .curations: return self.configureCurationSection()
            case .featured: return self.configureFeaturedSection()
            case .nearbys: return self.configureNearbySection()
            case .bookmarks: return self.configureBookmarkSection()
            case .regions: return self.configureRegionSection()
            case .noPermission, .emptyNearbys, .emptyBookmarks: return self.configureExceptionSection()
            }
        }
        return layout
    }
}
