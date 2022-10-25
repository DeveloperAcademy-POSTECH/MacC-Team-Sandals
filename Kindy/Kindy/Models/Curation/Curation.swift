//
//  CurationMain.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

struct Curation {
    let id: String
    let title: String
    let subTitle: String?
    
    let mainImage: String
    
    let headText: String
    let imageWithText: [(String, String)]
    let infoText: String
    
    let bookStore: Bookstore
}

extension Curation {
    static let item = Curation(id: "", title: "바쁜 일상,", subTitle: "잠시 쉬어갈 장소가 필요한 분들에게", mainImage: "testImage", headText: "📚 두두디북스 | 부산 수영구 \n\n✏️ 출입문부터 시작해 내부 인테리어까지 프라이빗한 아지트에 온 것 같은 느낌이 들었다.  공간이 생각보다 굉장히 넓었고, 펍 운영 공간은 이전에 생각하던 서점 분위기와는 반전되는 느낌이라 신선하고 재밌었다.  2016년부터 계속 자리를 지키고 있는 만큼 ‘만남’에 진심인 이 곳에서는 굉장히 다양한 클래스들을 개최하고 있어 부산에 계신 분이라면 시간을 내어 참여해봐도 좋을 것 같다", imageWithText: [("testImage", "얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~"), ("testImage", "두번째 얘는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~"), ("testImage", "세번째 는 달팽이 책방으로서 달팽이를 키우며 어저고 저쩌고 난리가 20000 저만 ~")], infoText: "몇시부터 몇시 ~ \n 부산광역시 수영구 수영로510번길 43 (광안동, 광남빌라) 지하 1층 \n💬 @doodoodibooks", bookStore: Bookstore(images: nil, name: "달팽이책방", address: "포항시 북구", telNumber: "010-1234-5678", emailAddress: nil, instagramURL: nil, businessHour: "09:00-18:00", description: "상세 설명", location: Location(latitude: 123, longitude: 3123)))
}
