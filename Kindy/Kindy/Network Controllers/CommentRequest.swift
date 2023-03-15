import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct CommentRequest: FirestoreRequest {
    typealias Response = Comment
    let parentCollectionPath = CollectionPath.curations
    let collectionPath = CollectionPath.comments
}

extension CommentRequest {
    /// 댓글 추가
    func add(curationID: String, userID: String, content: String, count: Int) async throws {
        let comment = Comment(id: UUID().uuidString, userID: userID, content: content, createdAt: Date())
        try await subdocumentReference(curationID, comment.id).setData(
            [
                "id": comment.id,
                "userID": comment.userID,
                "content": comment.content,
                "createdAt": comment.createdAt
            ]
        )

        try await CurationRequest().updateCommentCount(curationID: curationID, plus: true)
    }

    /// 댓글 삭제
    func delete(curationID: String, commentID: String, count: Int) async throws {
        try await subdocumentReference(curationID, commentID).delete()
        try await CurationRequest().updateCommentCount(curationID: curationID, plus: false)
    }
}

extension CommentRequest {
    /// 처음에 모든 댓글 불러오는 함수
    func fetch(with documentID: String) async throws -> [Comment] {
        let querySnapshot = try await subcollectionReference(documentID).getDocuments()
        let responses = try querySnapshot.documents.map { try $0.data(as: Comment.self) }
        return responses
    }
}
