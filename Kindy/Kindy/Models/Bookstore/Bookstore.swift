//
//  BookStore.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/18.
//

import UIKit
import FirebaseFirestoreSwift

struct Bookstore {
    var id: String = UUID().uuidString
    let images: [String]?
    let name: String
    var address: String
    let description: String
    let contact: Contact
    let businessHour: BusinessHour
    let location: Location
    var distance: Int = 0  // 내 주변 서점과 떨어진 거리(m)
}

extension Bookstore {
    // 짧은 주소
    var shortAddress: String {
        return address.components(separatedBy: " ")[0] + " " + address.components(separatedBy: " ")[1]
    }
}

extension Bookstore: Codable { }

extension Bookstore: Hashable { }

