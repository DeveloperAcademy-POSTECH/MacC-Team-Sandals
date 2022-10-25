//
//  BookStore.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/18.
//

import UIKit

// 서점 구조체(임시)
struct Bookstore: Hashable {
    
    let id = UUID()
    
    let images: [UIImage]?
    let name: String
    let address: String
    let telNumber: String?
    let emailAddress: String?
    let instagramURL: URL?
    let businessHour: String
    let description: String
    let location: Location
    var isFavorite = false
    
    // 짧은 주소
    var shortAddress: String {
        return address
    }
    
    // 내 주변 서점과 떨어진 거리(m)
    var meterDistance: Int {
        return 1
    }
    
    // 내 주변 서점까지 도보로 걸리는 시간(분)
    var timeDistance: Int {
        return 1
    }
    
    static func == (lhs: Bookstore, rhs: Bookstore) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let dummyData: [Bookstore] = [
        Bookstore(images: nil, name: "달팽이 책방1", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: "10:00 - 20:00", description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방2", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: "10:00 - 20:00", description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방3", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: "10:00 - 20:00", description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방4", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: "10:00 - 20:00", description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방5", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: "10:00 - 20:00", description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 10, longitude: 10))
    ]
}

// 서점의 위도와 경도를 표현하는 구조체
struct Location {
    let latitude: Double
    let longitude: Double
}

