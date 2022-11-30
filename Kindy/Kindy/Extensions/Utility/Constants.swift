//
//  Constants.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/17.
//

import Foundation

let padding8: CGFloat = 8
let padding16: CGFloat = 16
let padding24: CGFloat = 24

enum CollectionPath {
    static let bookstores = "Bookstores"
    static let curations = "Curations"
    static let users = "Users"
    static let comments = "Comment"
}

enum ImageSize {
    static let small = CGSize(width: 144*3, height: 144*3)
    static let medium = CGSize(width: 358*3, height: 358*3)
    static let big = CGSize(width: 1024*3, height: 1024*3)
}
