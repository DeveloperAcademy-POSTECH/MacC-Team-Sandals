//
//  ImageCacheManager.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/14.
//

import UIKit

struct ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
