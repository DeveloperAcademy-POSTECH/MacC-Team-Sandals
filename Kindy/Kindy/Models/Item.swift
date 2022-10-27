//
//  Item.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/18.
//

import Foundation

// 메인 Diffable Data Source에 쓰일 Item 열거형
enum Item: Hashable {
    case curation(Curation)
    case bookStore(Bookstore)
    case region(Region)
    case emptyNearby
    case emptyBookmark
    
    var curation: Curation? {
        if case .curation(let curation) = self {
            return curation
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
    
    // 같은 값이 들어가면 안됨(unique 해야함) -> 어떻게 구별? 다른 큐레이션 구조체(큐레이션 프로토콜 만들어도 괜찮으려나)를 만들어야하나 아니면 아이템의 케이스 하나 더 추가
    static let mainCuration: [Item] = [
        .curation(NewItems.curationDummy[Int.random(in: 0..<NewItems.curationDummy.count)])
    ]
    
    static let curations: [Item] = NewItems.curationDummy.map{ .curation($0) }
    
    // MARK 추후 데이터 로직으로 filter와 sort를 이용해 거리순으로 제거 후 입력 받는다
    static let nearByBookStores: [Item] = NewItems.bookstoreDummy.sorted{ $0.name > $1.name }.map{ .bookStore($0) }
    
    static let bookmarkedBookStores: [Item] = NewItems.bookstoreDummy.filter{ $0.isFavorite }.map{ .bookStore($0) }
    
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
