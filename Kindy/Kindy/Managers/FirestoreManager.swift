//
//  FirestoreManager.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/05.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreManager {
    enum Reference {
        static let db = Firestore.firestore()
        static let bookstores = db.collection("Bookstores")
    }
    
    // Bookstores 콜렉션의 모든 도규먼트를 fetch 하는 함수
    func fetchBookstores() async throws -> [ViewModel.Item] {
        let querySnapshot = try await Reference.bookstores.getDocuments()
        let bookstores = try querySnapshot.documents.map { try $0.data(as: Bookstore.self) }.map { ViewModel.Item.bookstore($0) }
        return bookstores
    }
}
