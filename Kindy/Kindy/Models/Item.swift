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
        .curation(Curation(id: "1", title: "바쁜 일상,", subTitle: "잠시 쉬어갈 장소가 필요한 분들에게", mainImage: "testImage", headText: "📚 두두디북스 | 부산 수영구 \n\n✏️ 출입문부터 시작해 내부 인테리어까지 프라이빗한 아지트에 온 것 같은 느낌이 들었다.  공간이 생각보다 굉장히 넓었고, 펍 운영 공간은 이전에 생각하던 서점 분위기와는 반전되는 느낌이라 신선하고 재밌었다.  2016년부터 계속 자리를 지키고 있는 만큼 ‘만남’에 진심인 이 곳에서는 굉장히 다양한 클래스들을 개최하고 있어 부산에 계신 분이라면 시간을 내어 참여해봐도 좋을 것 같다", imageWithText: [("testImage", "얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~ 시간을 내어 참여해봐도 좋을 것 같다 시간을 내어 참여해봐도 좋을 것 같다 시간을 내어 참여해봐도 좋을 것 같다 시간을 내어 참여해봐도 좋을 것 같다 시간을 내어 참여해봐도 좋을 것 같다"), ("testImage", "두번째 얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~"), ("testImage", "세번째 는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~")], infoText: "⏰ 몇시부터 몇시 ~ \n📍 부산광역시 수영구 수영로510번길 43 (광안동, 광남빌라) 지하 1층 \n💬 @doodoodibooks", bookStore: Bookstore(images: nil, name: "달팽이책방", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 36.0090456, longitude: 36.0090456))))
    ]
    
    static let curations: [Item] = [
        .curation(Curation(id: "2", title: "한가로운 일상,", subTitle: "잠시 쉬어갈 장소가 필요 없는 분들에게", mainImage: "testImage", headText: "📚 두두디북스 | 부산 수영구 \n\n✏️ 출입문부터 시작해 내부 인테리어까지 프라이빗한 아지트에 온 것 같은 느낌이 들었다.  공간이 생각보다 굉장히 넓었고, 펍 운영 공간은 이전에 생각하던 서점 분위기와는 반전되는 느낌이라 신선하고 재밌었다.  2016년부터 계속 자리를 지키고 있는 만큼 ‘만남’에 진심인 이 곳에서는 굉장히 다양한 클래스들을 개최하고 있어 부산에 계신 분이라면 시간을 내어 참여해봐도 좋을 것 같다", imageWithText: [("testImage", "얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~"), ("testImage", "두번째 얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~"), ("testImage", "세번째 는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~")], infoText: "몇시부터 몇시 ~ \n 부산광역시 수영구 수영로510번길 43 (광안동, 광남빌라) 지하 1층 \n💬 @doodoodibooks", bookStore: Bookstore(images: nil, name: "달팽이책방", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 36.0090456, longitude: 123)))),
        .curation(Curation(id: "3", title: "바쁜 일상,", subTitle: "잠시 쉬어갈 장소가 필요한 분들에게", mainImage: "testImage", headText: "📚 두두디북스 | 부산 수영구 \n\n✏️ 출입문부터 시작해 내부 인테리어까지 프라이빗한 아지트에 온 것 같은 느낌이 들었다.  공간이 생각보다 굉장히 넓었고, 펍 운영 공간은 이전에 생각하던 서점 분위기와는 반전되는 느낌이라 신선하고 재밌었다.  2016년부터 계속 자리를 지키고 있는 만큼 ‘만남’에 진심인 이 곳에서는 굉장히 다양한 클래스들을 개최하고 있어 부산에 계신 분이라면 시간을 내어 참여해봐도 좋을 것 같다", imageWithText: [("testImage", "얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~"), ("testImage", "두번째 얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~"), ("testImage", "세번째 는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~")], infoText: "몇시부터 몇시 ~ \n 부산광역시 수영구 수영로510번길 43 (광안동, 광남빌라) 지하 1층 \n💬 @doodoodibooks", bookStore: Bookstore(images: nil, name: "달팽이책방", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 54, longitude: 45)))),
        .curation(Curation(id: "4", title: "바쁜 일상,", subTitle: "잠시 쉬어갈 장소가 필요한 분들에게", mainImage: "testImage", headText: "📚 두두디북스 | 부산 수영구 \n\n✏️ 출입문부터 시작해 내부 인테리어까지 프라이빗한 아지트에 온 것 같은 느낌이 들었다.  공간이 생각보다 굉장히 넓었고, 펍 운영 공간은 이전에 생각하던 서점 분위기와는 반전되는 느낌이라 신선하고 재밌었다.  2016년부터 계속 자리를 지키고 있는 만큼 ‘만남’에 진심인 이 곳에서는 굉장히 다양한 클래스들을 개최하고 있어 부산에 계신 분이라면 시간을 내어 참여해봐도 좋을 것 같다", imageWithText: [("testImage", "얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~"), ("testImage", "두번째 얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~"), ("testImage", "세번째 는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~")], infoText: "몇시부터 몇시 ~ \n 부산광역시 수영구 수영로510번길 43 (광안동, 광남빌라) 지하 1층 \n💬 @doodoodibooks", bookStore: Bookstore(images: nil, name: "달팽이책방", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 66, longitude: 55)))),
        .curation(Curation(id: "5", title: "바쁜 일상,", subTitle: "잠시 쉬어갈 장소가 필요한 분들에게", mainImage: "testImage", headText: "📚 두두디북스 | 부산 수영구 \n\n✏️ 출입문부터 시작해 내부 인테리어까지 프라이빗한 아지트에 온 것 같은 느낌이 들었다.  공간이 생각보다 굉장히 넓었고, 펍 운영 공간은 이전에 생각하던 서점 분위기와는 반전되는 느낌이라 신선하고 재밌었다.  2016년부터 계속 자리를 지키고 있는 만큼 ‘만남’에 진심인 이 곳에서는 굉장히 다양한 클래스들을 개최하고 있어 부산에 계신 분이라면 시간을 내어 참여해봐도 좋을 것 같다", imageWithText: [("testImage", "얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~"), ("testImage", "두번째 얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~"), ("testImage", "세번째 는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~")], infoText: "몇시부터 몇시 ~ \n 부산광역시 수영구 수영로510번길 43 (광안동, 광남빌라) 지하 1층 \n💬 @doodoodibooks", bookStore: Bookstore(images: nil, name: "달팽이책방", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 44, longitude: 123)))),

    ]
    
    static let nearByBookStores: [Item] = [
        .bookStore(Bookstore(images: nil, name: "달팽이책방", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 36.0090456, longitude: 129.3331438))),
        .bookStore(Bookstore(images: nil, name: "달팽이책방2", address: "포항시 북구2", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명2", location: Location(latitude: 36.0090456, longitude: 129.3331438))),
        .bookStore(Bookstore(images: nil, name: "달팽이책방3", address: "포항시 북구3", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명3", location: Location(latitude: 36.0090456, longitude: 129.3331438))),
        .bookStore(Bookstore(images: nil, name: "달팽이책방1231", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 36.0090456, longitude: 129.3331438))),
        .bookStore(Bookstore(images: nil, name: "달팽이책방244", address: "포항시 북구2", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명2", location: Location(latitude: 36.0090456, longitude: 129.3331438))),
        .bookStore(Bookstore(images: nil, name: "달팽이책방31", address: "포항시 북구3", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명3", location: Location(latitude: 36.0090456, longitude: 129.3331438)))
    ]
    
    static let bookmarkedBookStores: [Item] = [
        .bookStore(Bookstore(images: nil, name: "달팽이책방아니다", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 36.0090456, longitude: 129.3331438), isFavorite: true)),
        .bookStore(Bookstore(images: nil, name: "달팽이책방2", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 36.0090456, longitude: 129.3331438), isFavorite: true)),
        .bookStore(Bookstore(images: nil, name: "달팽이책방3", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 36.0090456, longitude: 129.3331438), isFavorite: true)),
        .bookStore(Bookstore(images: nil, name: "달팽이책방4", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 36.0090456, longitude: 129.3331438), isFavorite: true)),
        .bookStore(Bookstore(images: nil, name: "달팽이책방5", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 36.0090456, longitude: 129.3331438), isFavorite: true))
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
