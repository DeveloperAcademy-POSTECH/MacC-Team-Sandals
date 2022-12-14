//
//  User.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/08.
//

import Foundation

struct User {
    let email: String
    let nickName: String
    let provider: String
    var bookmarkedBookstores: [String]
    var commentedCurations: [String]
}

extension User: Codable { }

extension User: Identifiable {
    var id: String { email + nickName }
}
