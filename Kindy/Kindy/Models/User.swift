//
//  User.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/08.
//

import Foundation

struct User {
    let id: String
    let nickName: String
    let bookmarkedBookstores: [String]
}

extension User: Codable { }