//
//  NSObject+.swift
//  Kindy
//
//  Created by rbwo on 2022/10/21.
//

import Foundation

extension NSObject {
    static var identifier: String {
        String(describing: self)
    }
}
