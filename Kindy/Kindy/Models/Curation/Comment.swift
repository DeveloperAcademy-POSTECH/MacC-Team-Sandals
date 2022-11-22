//
//  Comment.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/21.
//

import Foundation

struct Comment {
    let userID: String
    let content: String
    var createdAt = Date()
}

extension Comment: Codable { }

extension Comment: Hashable { }
