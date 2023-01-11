import CoreLocation
import UIKit

// MARK: - Bar appearance setting
extension HomeViewController: BarAppearanceSetting { }

// MARK: - Collection view delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]

        switch section {
        case .curations:
            let curation = model.curation.map { $0.curation ?? Curation.error }.first ?? Curation.error
            let curationViewController = PagingCurationViewController(curation: curation)
            curationViewController.modalPresentationStyle = .fullScreen
            curationViewController.modalTransitionStyle = .crossDissolve
            present(curationViewController, animated: true)
        case .featured:
            let featuredBookstores = model.featuredBookstores.map { $0.bookstore ?? Bookstore.error }
            let detailBookstoreViewController = DetailBookstoreViewController()
            detailBookstoreViewController.bookstore = featuredBookstores[indexPath.item]
            show(detailBookstoreViewController, sender: nil)
        case .nearbys:
            let bookstores = model.nearbyBookstores.map { $0.bookstore ?? Bookstore.error }
            let detailBookstoreViewController = DetailBookstoreViewController()
            detailBookstoreViewController.bookstore = bookstores[indexPath.item]
            show(detailBookstoreViewController, sender: nil)
        case .bookmarks:
            let bookmarkedBookstores = model.bookmarkedBookstores.map { $0.bookstore ?? Bookstore.error }
            let detailBookstoreViewController = DetailBookstoreViewController()
            detailBookstoreViewController.bookstore = bookmarkedBookstores[indexPath.item]
            show(detailBookstoreViewController, sender: nil)
        case .regions:
            let region = model.regions[indexPath.item].region
            let regionViewController = RegionViewController()
            regionViewController.setupData(regionName: region, items: model.bookstores)
            show(regionViewController, sender: nil)
        default:
            return
        }
    }
}

// MARK: - Section header delegate
extension HomeViewController: SectionHeaderDelegate {
    func segueWithSectionIndex(_ sectionIndex: Int) {
        switch sectionIndex {
        case 2:
            let nearbyBookstores = sortBookstoresByMyLocation(model.bookstores)
            let nearbyViewController = NearbyViewController()
            nearbyViewController.setupData(items: nearbyBookstores)
            show(nearbyViewController, sender: nil)
        case 3:
            let bookmarkedBookstores = model
                .bookmarkedBookstores
                .map { $0.bookstore ?? Bookstore.error }
            let bookmarkViewController = BookmarkViewController()
            bookmarkViewController.setupData(items: bookmarkedBookstores)
            show(bookmarkViewController, sender: nil)
        default:
            return
        }
    }
}

// MARK: - Scroll view delegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        var isHidden = false

        isHidden = velocity.y > 0 ? true : false
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }
}

// MARK: - Location manager delegate
extension HomeViewController: CLLocationManagerDelegate {
    /// 내 위치를 기준으로 서점 정렬.
    func sortBookstoresByMyLocation(
        _ bookstores: [Bookstore],
        showOnlyThreeItems: Bool = false
    ) -> [Bookstore] {
        guard let myLocation = locationManager.location?.coordinate as? CLLocationCoordinate2D
        else { return [] }

        var sortedBookstores = bookstores

        for index in bookstores.indices {
            sortedBookstores[index].distance = Int(
                myLocation
                    .distance(
                        from: CLLocationCoordinate2D(
                            latitude: sortedBookstores[index].location.latitude,
                            longitude: sortedBookstores[index].location.longitude
                            )
                    )
            )
        }

        sortedBookstores = sortedBookstores
            .filter { $0.distance < 15000 }
            .sorted { $0.distance < $1.distance }

        if showOnlyThreeItems {
            return Array(sortedBookstores.prefix(3))
        } else {
            return sortedBookstores
        }
    }

    /// 내 위치의 지역을 문자열로 반환.
    func fetchMyLocation() async throws -> String {
        guard let myLocation = locationManager.location?.coordinate as? CLLocationCoordinate2D
        else { return "" }

        let location = CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude)

        let placemarks = try await CLGeocoder().reverseGeocodeLocation(
            location,
            preferredLocale: Locale(identifier: "Ko-kr")
        )

        let locality = placemarks.first?.locality ?? ""
        let subLocality = placemarks.first?.subLocality ?? ""

        return locality + " " + subLocality
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            return
        case .authorizedWhenInUse, .authorizedAlways:
            model.nearbyBookstores = sortBookstoresByMyLocation(model.bookstores, showOnlyThreeItems: true)
                .map { .nearbyBookstore($0) }

            dataSource.apply(snapshot)
            return
        case .restricted, .denied:
            return
        @unknown default:
            return
        }
    }
}
