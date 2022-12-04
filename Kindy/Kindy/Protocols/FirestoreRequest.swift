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

protocol FirestoreRequest where Response: Codable & Identifiable {
    associatedtype Response
    
    var collectionPath: String { get }
}

extension FirestoreRequest {
    var db: Firestore { Firestore.firestore() }
}

extension FirestoreRequest {
    /// 모든 도큐먼트 fetch
    func fetch() async throws -> [Response] {
        let querySnapshot = try await db.collection(collectionPath).getDocuments()
        let responses = try querySnapshot.documents.map { try $0.data(as: Response.self) }
        return responses
    }
    
    /// 도큐먼트 id로 특정 도큐먼트 fetch
    func fetch(with documentID: String) async throws -> Response {
        return try await db.collection(collectionPath).document(documentID).getDocument(as: Response.self)
    }
    
    /// 도큐먼트 추가
    func add(_ document: Response) throws {
        try db.collection(collectionPath).document(document.id as? String ?? UUID().uuidString).setData(from: document)
    }
    
    /// id로 특정 도큐먼트 삭제
    func delete(_ documentID: String) async throws {
        try await db.collection(collectionPath).document(documentID).delete()
    }
}
