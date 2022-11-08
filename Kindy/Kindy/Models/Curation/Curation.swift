//
//  CurationMain.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

struct Curation {
    var id: String = UUID().uuidString
    let userID: String
    let bookstoreID: String
    let title: String
    let subTitle: String?
    var createdAt: Date? = Date()
    let headText: String
    let descriptions: [Description]
    let likes: [String]
}

extension Curation: Codable { }

extension Curation: Hashable { }
