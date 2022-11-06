//
//  CurationMain.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

struct Curation {
    let userID: String
    let bookstoreID: String
    let title: String
    let subTitle: String?
    let createdAt: String
    let headText: String
    let descriptions: [Description]
    let likes: [String]
}

extension Curation: Codable { }

extension Curation: Hashable { }
