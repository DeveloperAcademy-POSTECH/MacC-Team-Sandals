//
//  CurationMain.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import Foundation

struct Curation {
    var id: String = UUID().uuidString
    var userID: String
    var bookstoreID: String
    var category: String
    var mainImage: String
    var title: String
    var subTitle: String?
    var createdAt: Date? = Date()
    var headText: String
    var descriptions: [Description]
    var likes: [String]
    var comments: [Comment]?
    var commentCount: Int
}

extension Curation {
    static let error = Curation(
        userID: "",
        bookstoreID: "",
        category: "",
        mainImage: "",
        title: "오류가 발생했어요",
        headText: "",
        descriptions: [],
        likes: [],
        commentCount: 0
    )
}

extension Curation: Codable { }

extension Curation: Hashable { }

extension Curation: Identifiable { }
