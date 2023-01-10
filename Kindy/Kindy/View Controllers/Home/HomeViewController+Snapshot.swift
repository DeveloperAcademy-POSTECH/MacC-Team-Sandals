import UIKit

extension HomeViewController {
    var snapshot: NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item> {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()

        snapshot.appendSections([.curations])
        snapshot.appendItems(model.curation)

        snapshot.appendSections([.featured])
        snapshot.appendItems(model.featuredBookstores)

        switch locationManager.authorizationStatus {
        case .notDetermined, .denied, .restricted:
            snapshot.appendSections([.noPermission])
            snapshot.appendItems([.noPermission])
        default:
            if model.nearbyBookstores.isEmpty {
                snapshot.appendSections([.emptyNearbys])
                snapshot.appendItems([.noNearbyBookstore])
            } else {
                snapshot.appendSections([.nearbys])
                snapshot.appendItems(model.nearbyBookstores)
            }
        }

        if model.bookmarkedBookstores.isEmpty || !UserManager().isLoggedIn() {
            snapshot.appendSections([.emptyBookmarks])
            snapshot.appendItems([.noBookmarkedBookstore])
        } else {
            snapshot.appendSections([.bookmarks])
            snapshot.appendItems(model.bookmarkedBookstores)
        }

        snapshot.appendSections([.regions])
        snapshot.appendItems(model.regions)

        return snapshot
    }
}
