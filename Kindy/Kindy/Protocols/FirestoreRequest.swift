//
//  FirestoreRequest.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

protocol FirestoreRequest where Response: Codable {
    associatedtype Response
    
    var collectionPath: String { get }
}

extension FirestoreRequest {
    var db: Firestore { Firestore.firestore() }
}

extension FirestoreRequest {
    // 전부 fetch
    func fetch() async throws -> [Response] {
        let querySnapshot = try await db.collection(collectionPath).getDocuments()
        let responses = try querySnapshot.documents.map { try $0.data(as: Response.self) }
        return responses
    }
    
    // id로 fetch
    func fetch(with id: String) async throws -> Response {
        return try await db.collection(collectionPath).document(id).getDocument(as: Response.self)
    }
}
