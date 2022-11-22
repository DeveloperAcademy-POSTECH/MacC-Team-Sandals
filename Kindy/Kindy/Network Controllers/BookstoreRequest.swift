//
//  BookstoreRequest.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct BookstoreRequest: FirestoreRequest {
    typealias Response = Bookstore
    let collectionPath = CollectionPath.bookstores
    
    // 서점 추가
    func add(_ bookstore: Bookstore) throws {
        try db.collection(collectionPath).document(bookstore.id).setData(from: bookstore)
    }
    
    // 유저가 가진 서점 id 값으로 북마크된 서점 fetch
    func fetchBookmarkedBookstores() async throws -> [Bookstore] {
        let authManager = UserManager()
        
        if authManager.isLoggedIn() {
            let user = try await UserManager().fetchCurrentUser()
            var bookmarkedBookstores = [Bookstore]()
            
            for index in user.bookmarkedBookstores.indices {
                bookmarkedBookstores.append(try await fetch(with: user.bookmarkedBookstores[index]))
            }

            return bookmarkedBookstores
        } else {
            return []
        }
    }
}
