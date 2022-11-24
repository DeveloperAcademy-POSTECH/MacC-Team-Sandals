//
//  CurationRequest.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct CurationRequest: FirestoreRequest {
    typealias Response = Curation
    let collectionPath = CollectionPath.curations
    
    // 큐레이션 fetch
    func fetchWithComment(with id: String) async throws -> Curation {
        let curation = try await db.collection(collectionPath).document(id).getDocument(as: Curation.self)
        return curation
    }
    
    // 큐레이션 추가
    func add(curation: Curation) throws {
        try db.collection(collectionPath).document(curation.id).setData(from: curation)
    }
    
    // 큐레이션의 likes 업데이트
    func updateLike(bookstoreID: String, likes: [String]) async throws {
        let querySnapshot = try await db.collection(collectionPath).whereField("bookstoreID", isEqualTo: bookstoreID).getDocuments()
        let document = querySnapshot.documents.first
        try await document?.reference.updateData(["likes" : likes])
    }

    // 큐레이션이 가진 좋아요 값으로 fetch
//    func fetchLikesCurtions() async throws -> [Curation] {
//        if isLoggedIn() {
//            let user = try await fetchCurrentUser()
//            var likesCurations = [Curation]()
//            for index in user.curationLikes.indices {
//                likesCurations.append(try await fetchCuration(with: user.curstionLikes[index]))
//            }
//            return likesCurations
//        } else {
//            return []
//        }
//    }
}

extension CurationRequest {
    func createComment(curationID: String, userID: String ,content: String) throws {
        let comment = Comment(id: UUID().uuidString, userID: userID, content: content, createdAt: Date())
        try db.collection(collectionPath).document(curationID).collection("Comment").document(comment.id).setData(from: comment)
    }
    
    func deleteComment(curationID: String, commentID: String) {
        db.collection(collectionPath).document(curationID).collection("Comment").document(commentID).delete()
    }
}
