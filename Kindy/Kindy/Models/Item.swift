//
//  Item.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/18.
//

import Foundation

// 메인 Diffable Data Source에 쓰일 Item 열거형
enum Item: Hashable {
    case curation(TempCuration)
    case bookStore(Bookstore)
    case region(Region)
    
    var curation: TempCuration? {
        if case .curation(let tempCuration) = self {
            return tempCuration
        } else {
            return nil
        }
    }
    
    var bookStore: Bookstore? {
        if case .bookStore(let bookStore) = self {
            return bookStore
        } else {
            return nil
        }
    }
    
    var region: Region? {
        if case .region(let region) = self {
            return region
        } else {
            return nil
        }
    }
    
    // 같은 값이 들어가면 안됨(unique 해야함) -> 어떻게 구별? 다른 큐레이션 구조체를 만들어야하나
    static let mainCuration: [Item] = [.curation(TempCuration(title: "바쁜 일상, 잠시 쉬어갈 장소가 필요한 분들에게123"))]
    
    static let curations: [Item] = [
        .curation(TempCuration(title: "바쁜 일상, 잠시 쉬어갈 장소가 필요한 분들에게")),
        .curation(TempCuration(title: "큐레이션 2")),
        .curation(TempCuration(title: "큐레이션 3")),
        .curation(TempCuration(title: "큐레이션 4")),
        .curation(TempCuration(title: "큐레이션 5"))
    ]
    
    // TODO: 3개만 보이게 해야함(가까운 순으로) 필터링한 값을 넣어주는게 더 나을듯 - 컴포지셔널 레이아웃에서는 그냥 다 보여주는것 밖에 안되는것 같아서
    static let nearByBookStores: [Item] = [
        .bookStore(Bookstore(images: nil, name: "달팽이책방", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 123, longitude: 3123))),
        .bookStore(Bookstore(images: nil, name: "달팽이책방2", address: "포항시 북구2", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명2", location: Location(latitude: 1213, longitude: 31203))),
        .bookStore(Bookstore(images: nil, name: "달팽이책방3", address: "포항시 북구3", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명3", location: Location(latitude: 12423, longitude: 31523))),
        .bookStore(Bookstore(images: nil, name: "달팽이책방4", address: "포항시 북구4", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명4", location: Location(latitude: 1236, longitude: 31723))),
        .bookStore(Bookstore(images: nil, name: "달팽이책방5", address: "포항시 북구5", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명5", location: Location(latitude: 1231, longitude: 3113)))
    ]
    
    static let bookmarkedBookStores: [Item] = [
        .bookStore(Bookstore(images: nil, name: "달팽이책방", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 123, longitude: 3123), isFavorite: true)),
        .bookStore(Bookstore(images: nil, name: "달팽이책방2", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 123, longitude: 3123), isFavorite: true)),
        .bookStore(Bookstore(images: nil, name: "달팽이책방3", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 123, longitude: 3123), isFavorite: true)),
        .bookStore(Bookstore(images: nil, name: "달팽이책방4", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 123, longitude: 3123), isFavorite: true)),
        .bookStore(Bookstore(images: nil, name: "달팽이책방5", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 123, longitude: 3123), isFavorite: true))
    ]
    
    static let regions: [Item] = [
        .region(Region(name: "전체")),
        .region(Region(name: "서울")),
        .region(Region(name: "강원")),
        .region(Region(name: "경기/인천")),
        .region(Region(name: "충청/대전")),
        .region(Region(name: "경북/대구")),
        .region(Region(name: "전라/광주")),
        .region(Region(name: "경남/울산/부산")),
        .region(Region(name: "제주"))
    ]
}
