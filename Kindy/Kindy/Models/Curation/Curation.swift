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
    let category: String
    let mainImage: String
    let title: String
    let subTitle: String?
    var createdAt: Date? = Date()
    let headText: String
    let descriptions: [Description]
    var likes: [String]
    var comments: [Comment]?
}

extension Curation: Codable { }

extension Curation: Hashable { }
