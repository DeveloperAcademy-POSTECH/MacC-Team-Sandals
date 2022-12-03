//
//  CommentRequest.swift
//  Kindy
//
//  Created by rbwo on 2022/11/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CommentRequest: FirestoreRequest {
    typealias Response = Comment
    let collectionPath = CollectionPath.comments
}

extension CommentRequest {
    /// 댓글 추가
    func add(curationID: String, userID: String ,content: String, count: Int) async throws {
        let comment = Comment(id: UUID().uuidString, userID: userID, content: content, createdAt: Date())
        try await db.collection(CollectionPath.curations).document(curationID).collection(collectionPath).document(comment.id)
            .setData(
                [
                    "id" : comment.id,
                    "userID" : comment.userID,
                    "content" : comment.content,
                    "createdAt" : comment.createdAt
                ]
            )
        
        try await CurationRequest().updateCommentCount(curationID: curationID, count: count)
    }
    
    /// 댓글 삭제
    func delete(curationID: String, commentID: String, count: Int) async throws {
        try await db.collection(CollectionPath.curations).document(curationID).collection(collectionPath).document(commentID).delete()
        try await CurationRequest().updateCommentCount(curationID: curationID, count: count)
    }
}

extension CommentRequest {
    /// 처음에 모든 댓글 불러오는 함수
    func fetch(with documentID: String) async throws -> [Comment] {
        let querySnapshot = try await db.collection(CollectionPath.curations).document(documentID).collection(collectionPath).getDocuments()
        let responses = try querySnapshot.documents.map { try $0.data(as: Comment.self) }
        return responses
    }
    
    ///  댓글의 바뀐 부분만 불러오는 함수
    func update(curationID: String, completion: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration {
        return db.collection(CollectionPath.curations).document(curationID).collection(collectionPath).addSnapshotListener { querySnapshot, error in
            completion(querySnapshot,error)
        }
    }
}

/// 마이페이지의 댓글 단 글 관련 CommentRequest
extension CommentRequest {
    
    // 유저의 댓글 단 큐레이션 필드에 큐레이션 id 추가
    func addCommentedCuration(userID: String, curationID: String) throws {
        let field = db.collection(CollectionPath.users).document(userID)
        // arrayUnion: 현재 댓글을 작성한 큐레이션의 id가 유저의 필드에 이미 있다면 중복으로 업데이트하지 않음
        field.updateData(["commentedCurations": FieldValue.arrayUnion([curationID])])
    }
    
    // 댓글 삭제시 해당 큐레이션에서 자신의 댓글이 0개가 되면, 유저 필드의 commentedCurations에서 해당 큐레이션 id를 제거
    func deleteCommentedCurationIfNeeded(userID: String, curationID: String) async throws {
        let querySnapshot = try await db.collection(collectionPath).document(curationID).collection("Comment").whereField("userID", isEqualTo: userID).getDocuments()
        let myComments = try querySnapshot.documents.map { try $0.data(as: Comment.self) }
        
        switch myComments.count {
        case 1:
            let field = db.collection(CollectionPath.users).document(userID)
            try await field.updateData(["commentedCurations": FieldValue.arrayRemove([curationID])])
            
        default:
            break
        }
    }
    
    // 큐레이션 삭제시 댓글 단 유저들의 commentedCurations의 필드에서 해당 큐레이션 id를 제거
    func deleteAllCommentedCuration(curationID: String) async throws {
        let querySanpshot = try await db.collection(CollectionPath.curations).document(curationID).collection("Comment").getDocuments()
        let comments = try querySanpshot.documents.map { try $0.data(as: Comment.self) }
        
        // 이미 해당 큐레이션의 id를 필드에서 제거한 유저의 리스트
        // 한 유저의 댓글이 여러개일 경우, 2번 이상 해당 유저의 필드를 접근하지 않기 위함
        var repeatedUserID: [String] = []
        
        for i in comments.indices {
            let currentUserID = comments[i].userID
            guard !repeatedUserID.contains(currentUserID) else { continue }
            
            repeatedUserID.append(currentUserID)
            let field = db.collection(CollectionPath.users).document(currentUserID)
            try await field.updateData(["commentedCurations": FieldValue.arrayRemove([curationID])])
        }
    }
    
}
