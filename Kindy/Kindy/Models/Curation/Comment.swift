//
//  Comment.swift
//  Kindy
//
//  Created by rbwo on 2022/11/21.
//

import Foundation

struct Comment {
    let id: String
    let userID: String
    let content: String
    var createdAt: Date = Date()
    var userNickname: String?
}

extension Comment: Codable { }

extension Comment: Hashable { }

extension Comment: Identifiable { }
