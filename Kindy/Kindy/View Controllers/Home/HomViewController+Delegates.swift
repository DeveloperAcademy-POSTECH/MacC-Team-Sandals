//
//  HomViewController+Delegates.swift
//  Kindy
//
//  Created by 정호윤 on 2022/12/03.
//

import UIKit
import CoreLocation

// MARK: - Bar Appearance Delegate

extension HomeViewController: BarAppearanceDelegate { }

// MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        
        switch section {
        case .curations:
            let curation = model.curation.map { $0.curation ?? Curation.error }.first!
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
            regionViewController.setupData(regionName: region!, items: model.bookstores)
            
            show(regionViewController, sender: nil)
        default:
            return
        }
    }
}

// MARK: - Section Header Delegate

extension HomeViewController: SectionHeaderDelegate {
    
    func segueWithSectionIndex(_ sectionIndex: Int) {
        switch sectionIndex {
        case 2:
            let nearbyBookstores = model.nearbyBookstores.map { $0.bookstore ?? Bookstore.error }
            let nearbyViewController = NearbyViewController()
            nearbyViewController.setupData(items: nearbyBookstores)
            show(nearbyViewController, sender: nil)
        case 3:
            let bookmarkedBookstores = model.bookmarkedBookstores.map { $0.bookstore ?? Bookstore.error }
            let bookmarkViewController = BookmarkViewController()
            bookmarkViewController.setupData(items: bookmarkedBookstores)
            show(bookmarkViewController, sender: nil)
        default:
            return
        }
    }
}


// MARK: - Scroll View Delegate

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (velocity.y > 0) {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    
    // 내 위치를 기준으로 서점 정렬
    func sortBookstoresByMyLocation(_ bookstores: [Bookstore]) -> [Bookstore] {
        guard let myLocation = locationManager.location?.coordinate as? CLLocationCoordinate2D else { return [] }
        var sortedBookstores = bookstores
        
        for i in bookstores.indices {
            sortedBookstores[i].distance = Int(myLocation.distance(from: CLLocationCoordinate2D(latitude: sortedBookstores[i].location.latitude, longitude: sortedBookstores[i].location.longitude)))
        }
        
        sortedBookstores = sortedBookstores.filter { $0.distance < 100000 }.sorted { $0.distance < $1.distance }
        
        return Array(sortedBookstores.prefix(3))
    }
    
    // 내 위치의 지역을 문자열로 반환
    func fetchMyLocation() async throws -> String {
        guard let myLocation = locationManager.location?.coordinate as? CLLocationCoordinate2D else { return "" }
        
        let location = CLLocation(latitude: myLocation.latitude, longitude: myLocation.longitude)
        
        let placemarks = try await CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "Ko-kr"))
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
            model.nearbyBookstores = sortBookstoresByMyLocation(model.bookstores).map { .nearbyBookstore($0) }
            dataSource.apply(snapshot)
            return
        case .restricted, .denied:
            return
        @unknown default:
            return
        }
    }
}
