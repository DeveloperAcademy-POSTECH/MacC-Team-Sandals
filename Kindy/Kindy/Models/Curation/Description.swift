//
//  Description.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/05.
//

import Foundation

struct Description {
    let image: String?
    let content: String?
}

extension Description: Codable { }

extension Description: Hashable { }
