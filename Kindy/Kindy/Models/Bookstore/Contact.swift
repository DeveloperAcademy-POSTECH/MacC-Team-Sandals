//
//  Contact.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/05.
//

import Foundation

struct Contact {
    let telNumber: String?
    let emailAddress: String?
    let instagramURL: String?
}

extension Contact: Codable { }

extension Contact: Hashable { }
