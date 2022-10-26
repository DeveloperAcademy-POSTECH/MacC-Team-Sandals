//
//  CurationMain.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

struct Curation: Hashable {
    
    let id: String
    let title: String
    let subTitle: String?
    
    let mainImage: String
    
    let headText: String
    let imageWithText: [(String, String)]
    let infoText: String
    
    let bookStore: Bookstore
    
    static func == (lhs: Curation, rhs: Curation) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
