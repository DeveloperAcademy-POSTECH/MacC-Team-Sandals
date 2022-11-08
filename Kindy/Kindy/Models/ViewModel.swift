//
//  Item.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/18.
//

import Foundation

enum ViewModel {
    enum Section: Hashable {
        case curation
        case nearby
        case bookmarked
        case region
    }

    enum Item: Hashable {
        case curation(Curation)
        case bookstore(Bookstore)
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
            case .bookstore(let bookstore):
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
   
    
