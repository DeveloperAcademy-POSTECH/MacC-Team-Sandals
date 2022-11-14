//
//  ViewModel.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/18.
//

import Foundation

enum ViewModel {
    enum Section: Hashable {
        case curations
        case bookstores
        case nearbys
        case bookmarks, emptyBookmarks
        case regions
        case noPermission
    }

    enum Item: Hashable {
        case curation(Curation)
        case featuredBookstore(Bookstore)
        case nearbyBookstore(Bookstore)
        case bookmarkedBookstore(Bookstore), noBookmarkedBookstore
        case region(String)
        case noPermission
        
        var curation: Curation? {
            if case .curation(let curation) = self {
                return curation
            } else {
                return nil
            }
        }
        
        var bookstore: Bookstore? {
            switch self {
            case .featuredBookstore(let bookstore):
                return bookstore
            case .nearbyBookstore(let bookstore):
                return bookstore
            case .bookmarkedBookstore(let bookstore):
                return bookstore
            default:
                return nil
            }
        }
        
        var region: String? {
            if case .region(let region) = self {
                return region
            } else {
                return nil
            }
        }
    }
}
   
    
