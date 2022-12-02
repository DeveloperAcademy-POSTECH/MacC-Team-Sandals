//
//  BookstoreRequest.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/21.
//

import Foundation
import FirebaseFirestoreSwift

struct BookstoreRequest: FirestoreRequest {
    typealias Response = Bookstore
    let collectionPath = CollectionPath.bookstores
}
 
extension BookstoreRequest {   
    // 유저가 가진 서점 id 값으로 북마크된 서점 fetch
    func fetchBookmarkedBookstores() async throws -> [Bookstore] {
        guard UserManager().isLoggedIn() else { return [] }
        
        let user = try await UserManager().fetchCurrentUser()
        var bookmarkedBookstores = [Bookstore]()
        
        for index in user.bookmarkedBookstores.indices {
            bookmarkedBookstores.append(try await fetch(with: user.bookmarkedBookstores[index]))
        }
        
        return bookmarkedBookstores
    }
}
