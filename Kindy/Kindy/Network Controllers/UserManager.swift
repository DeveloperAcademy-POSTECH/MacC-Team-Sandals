//
//  UserManager.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/05.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserManager: FirestoreRequest {
    typealias Response = User
    let collectionPath = CollectionPath.users
}

// MARK: 유저 데이터
extension UserManager {
    /// 유저의 도큐먼트 id fetch
    func getID() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    /// 현재 로그인되어 있는 정보로 유저 데이터 fetch
    func fetchCurrentUser() async throws -> User {
        return try await documentReference(Auth.auth().currentUser?.uid ?? "").getDocument(as: User.self)
    }
    
    /// 북마크 데이터 변경
    func updateBookmark(email: String, provider: String, bookmarkedBookstores: [String]) async throws {
        let querySnapshot = try await collectionReference.whereField("email", isEqualTo: email).whereField("provider", isEqualTo: provider).getDocuments()
        let document = querySnapshot.documents.first
        try await document?.reference.updateData(["bookmarkedBookstores" : bookmarkedBookstores])
    }
}

// MARK: 유저 상태 관련
extension UserManager {
    /// 현재 로그인 여부 확인
    func isLoggedIn() -> Bool {
        return !(Auth.auth().currentUser == nil)
    }
    
    /// 로그아웃
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    /// 이미 가입한 유저인지 확인
    func isExistingUser(_ email: String?, _ provider: String) async throws -> Bool {
        if let email = email {
            return try await !collectionReference.whereField("email", isEqualTo: email).whereField("provider", isEqualTo: provider).getDocuments().documents.map{ $0.documentID }.isEmpty
        } else {
            return false
        }
    }
    
    /// 유저 삭제
    func delete() {
        let auth = Auth.auth().currentUser
        
        documentReference(auth?.uid ?? "al").delete() { _ in
            auth?.delete()
        }
    }
}

// MARK: 닉네임
extension UserManager {
    /// 닉네임 중복확인
    func isExistingNickname(_ nickName: String) async throws -> Bool {
        let nickNames = try await collectionReference.getDocuments().documents.map{ $0.data() }.filter{ String(describing: $0["nickName"]!) == nickName }
        return !nickNames.isEmpty
    }

    /// 닉네임 수정
    func editNickname(_ newNickname: String) {
        documentReference(Auth.auth().currentUser?.uid ?? "").updateData(["nickName": newNickname])
    }
}

// MARK: 마이페이지에서 사용하는 CurationRequest
extension UserManager {
    /// 내가 작성한 큐레이션 fetch
    func fetchMyCurations(userID: String) async throws -> [Curation] {
        let querySnapShot = try await db.collection(CollectionPath.curations).whereField("userID", isEqualTo: userID).getDocuments()
        let document = try querySnapShot.documents.map { try $0.data(as: Curation.self) }
        return document.reversed()
    }
    
    /// 좋아요 한 큐레이션 fetch
    func fetchLikedCurations(userID: String) async throws -> [Curation] {
        let querySnapshot = try await db.collection(CollectionPath.curations).whereField("likes", arrayContains: userID).getDocuments()
        let document = try querySnapshot.documents.map { try $0.data(as: Curation.self) }
        return document.reversed()
    }
    
    /// 댓글 단 큐레이션 fetch
    func fetchCommentedCurations(userID: String) async throws -> [Curation] {
        // 현재 유저의 document 데이터를 가져와서
        let documentSnapshot = try await documentReference(userID).getDocument()
        let user = try documentSnapshot.data(as: User.self)
        var commentedCurations: [Curation] = []
        
        // 유저가 댓글 단 글을 하나씩 순회하며 각 큐레이션을 commentedCurations에 추가
        for i in user.commentedCurations.indices {
            let index = (user.commentedCurations.count-1-i)
            // 최신 댓글 순서로 append
            let curationID = user.commentedCurations[index]
            let querysnapShot = try await db.collection(CollectionPath.curations).whereField("id", isEqualTo: curationID).getDocuments()
            let curation = try querysnapShot.documents.map { try $0.data(as: Curation.self) }
            
            guard let curation = curation.first else { return commentedCurations }
            
            commentedCurations.append(curation)
        }
        
        return commentedCurations
    }
    
}

/// 마이페이지의 댓글 단 글 관련 CommentRequest
extension UserManager {
    
    // 유저의 댓글 단 큐레이션 필드에 큐레이션 id 추가
    func addCommentedCuration(userID: String, curationID: String) throws {
        let field = db.collection(collectionPath).document(userID)
        // arrayUnion: 현재 댓글을 작성한 큐레이션의 id가 유저의 필드에 이미 있다면 중복으로 업데이트하지 않음
        field.updateData(["commentedCurations": FieldValue.arrayUnion([curationID])])
    }
    
    // 댓글 삭제시 해당 큐레이션에서 자신의 댓글이 0개가 되면, 유저 필드의 commentedCurations에서 해당 큐레이션 id를 제거
    func deleteCommentedCurationIfNeeded(userID: String, curationID: String) async throws {
        let querySnapshot = try await db.collection(CollectionPath.curations).document(curationID).collection(CollectionPath.comments).whereField("userID", isEqualTo: userID).getDocuments()
        let myComments = querySnapshot.documents.compactMap { comment in
            try? comment.data(as: Comment.self)
        }
        
        switch myComments.count {
        case 1:
            let field = db.collection(collectionPath).document(userID)
            try await field.updateData(["commentedCurations": FieldValue.arrayRemove([curationID])])
            
        default:
            break
        }
    }
    
    // 큐레이션 삭제시 댓글 단 유저들의 commentedCurations의 필드에서 해당 큐레이션 id를 제거
    func deleteAllCommentedCuration(curationID: String) async throws {
        let querySanpshot = try await db.collection(CollectionPath.curations).document(curationID).collection(CollectionPath.comments).getDocuments()
        let comments = try querySanpshot.documents.map { try $0.data(as: Comment.self) }
        
        // 이미 해당 큐레이션의 id를 필드에서 제거한 유저의 리스트
        // 한 유저의 댓글이 여러개일 경우, 2번 이상 해당 유저의 필드를 접근하지 않기 위함
        var repeatedUserID: [String] = []
        
        for i in comments.indices {
            let currentUserID = comments[i].userID
            guard !repeatedUserID.contains(currentUserID) else { continue }
            
            repeatedUserID.append(currentUserID)
            let field = db.collection(collectionPath).document(currentUserID)
            try await field.updateData(["commentedCurations": FieldValue.arrayRemove([curationID])])
        }
    }
    
}
