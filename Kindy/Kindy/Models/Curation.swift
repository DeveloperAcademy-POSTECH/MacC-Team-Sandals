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

extension Curation: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Curation, rhs: Curation) -> Bool {
        return lhs.id == rhs.id
    }
}
