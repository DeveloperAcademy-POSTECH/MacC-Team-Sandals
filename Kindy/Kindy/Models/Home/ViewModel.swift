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
        case bookmarks
        case regions
    }

    enum Item: Hashable {
        case curation(Curation)
        case featuredBookstore(Bookstore)
        case nearByBookstore(Bookstore)
        case bookmarkedBookstore(Bookstore)
        case region(String)
        
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
            case .nearByBookstore(let bookstore):
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
   
    
