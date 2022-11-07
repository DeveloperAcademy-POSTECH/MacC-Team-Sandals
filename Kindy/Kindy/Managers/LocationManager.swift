//
//  LocationManager.swift
//  niberground
//
//  Created by rbwo on 2022/10/26.
//

import UIKit
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func nearFilter(datas: [Bookstore]) -> [Bookstore] {
        var filteredData: [Bookstore] = datas
        
        guard let from = manager.location?.coordinate as? CLLocationCoordinate2D else { return [] }
        
        for i in 0..<filteredData.count {
            fetchLocationData(index: i ,latitude: filteredData[i].location.latitude, longitude: filteredData[i].location.longitude)
            
            filteredData[i].meterDistance = Int(from.distance(from: CLLocationCoordinate2D(latitude: filteredData[i].location.latitude, longitude: filteredData[i].location.longitude)))
        }
        
        return filteredData.sorted { first, second in
            first.meterDistance < second.meterDistance
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined :
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            Bookstore.filteredData = nearFilter(datas: Bookstore.locationDummyData)
            break
        case .authorizedAlways:
            break
        case .restricted :
            break
        case .denied :
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
    private func fetchLocationData(index: Int, latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")

        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.first?.thoroughfare,
                  let subAddress = placemarks.first?.subThoroughfare
            else { return }
            
            Bookstore.filteredData[index].address = address + " " + subAddress
        }
    }
}

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to)
    }
}

