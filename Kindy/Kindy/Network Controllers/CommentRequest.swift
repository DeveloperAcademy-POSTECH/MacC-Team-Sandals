//
//  CommentRequest.swift
//  Kindy
//
//  Created by rbwo on 2022/11/24.
//

import Foundation
import FirebaseFirestoreSwift

struct CommentRequest: FirestoreRequest {
    typealias Response = Comment
    let collectionPath = CollectionPath.comments
}

extension CommentRequest {
    func fetchComment(id: String) async throws -> [Comment] {
        let querySnapshot = try await db.collection(CollectionPath.curations).document(id).collection(collectionPath).getDocuments()
        let responses = try querySnapshot.documents.map { try $0.data(as: Comment.self) }
        return responses
    }
}
