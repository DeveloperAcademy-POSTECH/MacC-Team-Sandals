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
        static let curations = db.collection("Curations")
        static let users = db.collection("Users")
    }
    
    // TODO: 유저 데이터 저장하는 함수
    
    // TODO: 서점, 큐레이션 id로 도큐먼트 가져오기(쿼리 대신)
}

// MARK: - 큐레이션

extension FirestoreManager {
    // 모든 큐레이션 fetch
    func fetchCurations() async throws -> [ViewModel.Item] {
        let querySnapshot = try await Reference.curations.getDocuments()
        let curations = try querySnapshot.documents.map { try $0.data(as: Curation.self) }.map { ViewModel.Item.curation($0) }
        return curations
    }
}

// MARK: -  서점

extension FirestoreManager {
    // 모든 서점 fetch
    func fetchBookstores() async throws -> [ViewModel.Item] {
        let querySnapshot = try await Reference.bookstores.getDocuments()
        let bookstores = try querySnapshot.documents.map { try $0.data(as: Bookstore.self) }.map { ViewModel.Item.bookstore($0) }
        return bookstores
    }
}

// MARK: -  유저

extension FirestoreManager {
    // 유저 추가
    func addUser(with id: String) async throws {
        let user = User(id: id, nickName: "", bookmarkedBookstores: [])
        try Reference.users.document(user.id).setData(from: user)
    }
}
