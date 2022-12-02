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

extension Curation: Codable { }

extension Curation: Hashable { }

extension Curation: Identifiable { }
