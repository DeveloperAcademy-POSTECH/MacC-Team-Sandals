//
//  FirestoreManager.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/05.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreManager {
    enum Reference {
        static let db = Firestore.firestore()
        static let bookstores = db.collection("Bookstores")
        static let curations = db.collection("Curations")
        static let users = db.collection("Users")
    }
}

// MARK: - 큐레이션

extension FirestoreManager {
    // 모든 큐레이션 fetch
    func fetchCurations() async throws -> [Curation] {
        let querySnapshot = try await Reference.curations.getDocuments()
        let curations = try querySnapshot.documents.map { try $0.data(as: Curation.self) }
        return curations
    }
    
    // id로 큐레이션 fetch
    func fetchCuration(by id: String) async throws -> Curation {
        let curation = try await Reference.curations.document(id).getDocument(as: Curation.self)
        return curation
    }
    
    // 큐레이션 추가
    func add(curation: Curation) throws {
        try Reference.curations.document(curation.id).setData(from: curation)
    }
}

// MARK: -  서점

extension FirestoreManager {
    // 모든 서점 fetch
    func fetchBookstores() async throws -> [Bookstore] {
        let querySnapshot = try await Reference.bookstores.getDocuments()
        let bookstores = try querySnapshot.documents.map { try $0.data(as: Bookstore.self) }
        return bookstores
    }
    
    // id로 서점 fetch
    func fetchBookstore(by id: String) async throws -> Bookstore {
        let bookstore = try await Reference.bookstores.document(id).getDocument(as: Bookstore.self)
        return bookstore
    }
    
    // 서점 추가
    func add(bookstore: Bookstore) throws {
        try Reference.bookstores.document(bookstore.id).setData(from: bookstore)
    }
}

// MARK: -  유저

extension FirestoreManager {
    // 유저 추가
    func add(user id: String, nickName: String) throws {
        let user = User(id: id, nickName: nickName, bookmarkedBookstores: [])
        try Reference.users.document(user.id).setData(from: user)
    }
    
    // 이메일로 유저 fetch
    func fetchUser(by email: String) async throws -> User {
        let user = try await Reference.users.document(email).getDocument(as: User.self)
        return user
    }
}

// MARK: - 이미지

extension FirestoreManager {
    enum ImageRequestError: Error {
        case couldNotInitializeFromData
        case imageDataMissing
    }
    
    func fetchImage(by url: String?) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: URL(string: url ?? "")!)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ImageRequestError.imageDataMissing
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageRequestError.couldNotInitializeFromData
        }
        
        return image
    }
}
