//
//  BookStore.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/18.
//

import UIKit

// 서점 구조체(임시)
struct Bookstore {
    
    let id = UUID()
    
    let images: [UIImage]?
    let name: String
    var address: String
    let telNumber: String?
    let emailAddress: String?
    let instagramURL: String?
    let businessHour: BusinessHour
    let description: String
    let location: Location
    var isFavorite = false
    
    // 짧은 주소
    var shortAddress: String {
        return address.components(separatedBy: " ")[0] + " " + address.components(separatedBy: " ")[1]
    }
    
    // 내 주변 서점과 떨어진 거리(m)
    var meterDistance: Int = 1
    
    // 내 주변 서점까지 도보로 걸리는 시간(분)
    var timeDistance: Int {
        return 1
    }
    
    static let dummyData: [Bookstore] = [
        Bookstore(images: nil, name: "달팽이 책방1", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: BusinessHour(), description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방2", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: BusinessHour(), description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방3", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: BusinessHour(), description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방4", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: BusinessHour(), description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 10, longitude: 10)),
        Bookstore(images: nil, name: "달팽이 책방5", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: BusinessHour(), description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 10, longitude: 10))
    ]
    
    static let locationDummyData: [Bookstore] = [
        Bookstore(images: nil, name: "투 썸 ", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: BusinessHour(), description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 36.014295, longitude: 129.325791)),
        Bookstore(images: nil, name: "멀티패쓰 ", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: BusinessHour(), description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 36.008379, longitude: 129.330679)),
        Bookstore(images: nil, name: "현대 음식", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: BusinessHour(), description: "내 손 안의 독립서점, 킨디", location: Location(latitude: 36.005573, longitude: 129.324763)),
        Bookstore(images: nil, name: "시외터미널", address: "포항시 남구", telNumber: "020202020", emailAddress: "teamsandalsofficial@gmail.com", instagramURL: nil, businessHour: BusinessHour(), description: "내 손 안의 독립서점, 킨디", location:  Location(latitude: 36.012628, longitude: 129.349983))
    ]
    
    static var filteredData: [Bookstore] = []
}

extension Bookstore: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Bookstore, rhs: Bookstore) -> Bool {
        return lhs.id == rhs.id
    }
}

