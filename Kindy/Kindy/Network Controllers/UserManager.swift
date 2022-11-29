//
//  UserManager.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/05.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth

struct UserManager: FirestoreRequest {
    typealias Response = User
    let collectionPath = CollectionPath.users
}

// MARK: 유저 데이터
extension UserManager {
    // 유저 documentID fetch
    func getID() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    // 현재 로그인되어 있는 정보로 유저 데이터 fetch
    func fetchCurrentUser() async throws -> User {
        return try await db.collection(collectionPath).document(Auth.auth().currentUser?.uid ?? "").getDocument(as: User.self)
    }
    
    // 북마크 데이터 변경
    func updateBookmark(email: String, provider: String, bookmarkedBookstores: [String]) async throws {
        let querySnapshot = try await db.collection(collectionPath).whereField("email", isEqualTo: email).whereField("provider", isEqualTo: provider).getDocuments()
        let document = querySnapshot.documents.first
        try await document?.reference.updateData(["bookmarkedBookstores" : bookmarkedBookstores])
    }
}

// MARK: 유저 상태 관련
extension UserManager {
    // 현재 로그인 여부 확인
    func isLoggedIn() -> Bool {
        return !(Auth.auth().currentUser == nil)
    }
    
    // 로그아웃
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    // 이미 가입한 유저인지 확인
    func isExistingUser(_ email: String?, _ provider: String) async throws -> Bool {
        if let email = email {
            return try await !db.collection(collectionPath).whereField("email", isEqualTo: email).whereField("provider", isEqualTo: provider).getDocuments().documents.map{ $0.documentID }.isEmpty
        } else {
            return false
        }
    }
    
    // 유저 삭제
    func delete() {
        let auth = Auth.auth().currentUser

        db.collection(collectionPath).document(auth?.uid ?? "al").delete() { _ in
            auth?.delete()
        }
    }
}

// MARK: 닉네임
extension UserManager {
    // 닉네임 중복확인
    func isExistingNickname(_ nickName: String) async throws -> Bool {
        let nickNames = try await db.collection(collectionPath).getDocuments().documents.map{ $0.data() }.filter{ String(describing: $0["nickName"]!) == nickName }
        return !nickNames.isEmpty
    }

    // 닉네임 수정
    func editNickname(_ newNickname: String) {
        let user = db.collection(collectionPath).document(Auth.auth().currentUser?.uid ?? "")
        user.updateData(["nickName": newNickname])
    }
}
