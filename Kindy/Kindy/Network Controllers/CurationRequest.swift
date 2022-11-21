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
    
    // 댓글을 포함한 큐레이션 fetch
    func fetchWithComment(with id: String) async throws -> Curation {
        var curation = try await db.collection(collectionPath).document(id).getDocument(as: Curation.self)
        let querySnapshot = try await db.collection(collectionPath).document(curation.id).collection(CollectionPath.comments).getDocuments()
        curation.comments = try querySnapshot.documents.map { try $0.data(as: Comment.self) }
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
