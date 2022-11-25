//
//  FirestoreManager.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/05.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct FirestoreManager {
    static let db = Firestore.firestore()
    let bookstores = db.collection("Bookstores")
    let curations = db.collection("Curations")
    let users = db.collection("Users")
}

// MARK: 큐레이션
extension FirestoreManager {
    // 모든 큐레이션 fetch
    func fetchCurations() async throws -> [Curation] {
        let querySnapshot = try await curations.getDocuments()
        let curations = try querySnapshot.documents.map { try $0.data(as: Curation.self) }
        return curations
    }
    
    // id로 큐레이션 fetch
    func fetchCuration(with id: String) async throws -> Curation {
        let curation = try await curations.document(id).getDocument(as: Curation.self)
        return curation
    }
    
    // 큐레이션 추가
    func add(curation: Curation) throws {
        try curations.document(curation.id).setData(from: curation)
    }
}

// MARK: 서점
extension FirestoreManager {
    // 모든 서점 fetch
    func fetchBookstores() async throws -> [Bookstore] {
        let querySnapshot = try await bookstores.getDocuments()
        let bookstores = try querySnapshot.documents.map { try $0.data(as: Bookstore.self) }
        return bookstores
    }
    
    // id로 서점 fetch
    func fetchBookstore(with id: String) async throws -> Bookstore {
        let bookstore = try await bookstores.document(id).getDocument(as: Bookstore.self)
        return bookstore
    }
    
    // 서점 추가
    func add(bookstore: Bookstore) throws {
        try bookstores.document(bookstore.id).setData(from: bookstore)
    }
}

// MARK: 유저
extension FirestoreManager {
    // 유저 추가
    func add(user email: String, nickName: String) throws {
        let user = User(email: email, nickName: nickName, provider: "", bookmarkedBookstores: [])
        try users.document(user.email).setData(from: user)
    }
    
    // 이메일로 유저 fetch
    func fetchUser(with email: String) async throws -> User {
        let user = try await users.document(email).getDocument(as: User.self)
        return user
    }
    
    // 현재 로그인되어 있는 정보로 유저 데이터 fetch
    // MARK: 회원가입 로직 변경 후 수정 예정
    func fetchCurrentUser() async throws -> User {
        let auth = Auth.auth().currentUser
        let email = auth?.email
        // MARK: 로직 변경으로 Google 로그인도 uid 로 도큐먼트 id 값을 가지므로, 기존 유저만 찾아내기 위한 배열, 추후 유저 정리후 삭제 필요 , 삭제하면 if 로직을 실행하지 않으므로, 성능개선
        let user = try await users.document(Auth.auth().currentUser?.uid ?? "").getDocument(as: User.self)
        return user
    }
    
    // 이미 존재하는 닉네임 확인
    func isExistingNickname(_ nickName: String) async throws -> Bool {
        let nickNames = try await FirestoreManager.db.collection("Users").getDocuments().documents.map{ $0.data() }.filter{ String(describing: $0["nickName"]!) == nickName }
        return !nickNames.isEmpty
    }
    
    // 이미 가입한 유저인지 확인
    func isExistingUser(_ email: String?, _ provider: String) async throws -> Bool {
        if let email = email {
            return try await !FirestoreManager.db.collection("Users").whereField("email", isEqualTo: email).whereField("provider", isEqualTo: provider).getDocuments().documents.map{ $0.documentID }.isEmpty
        } else {
            return false
        }
        
    }
    

    // 닉네임 수정
    func editNickname(_ newNickname: String) {
        let user = users.document(Auth.auth().currentUser?.uid ?? "")
        user.updateData(["nickName": newNickname])
    }

    // 유저 삭제
    func deleteUser() {
        users.document(Auth.auth().currentUser?.uid ?? "al").delete() { _ in
            Auth.auth().currentUser?.delete()
        }
    }

    // 유저 documentID fetch
    func getUserID() -> String {
        if let uid = Auth.auth().currentUser?.uid {
            return uid
        } else {
            return ""
        }
    }
}

// MARK: 이미지
extension FirestoreManager {
    enum ImageRequestError: Error {
        case invalidURL
        case imageDataMissing
        case couldNotInitializeFromData
    }
    
    func fetchImage(with url: String?) async throws -> UIImage {
        let cachedKey = NSString(string: url ?? "")
        if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) { return cachedImage }
        
        guard let url = URL(string: url ?? "") else { throw ImageRequestError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ImageRequestError.imageDataMissing }
        
        guard let image = UIImage(data: data) else { throw ImageRequestError.couldNotInitializeFromData }
        
        ImageCacheManager.shared.setObject(image, forKey: cachedKey)
        
        return image
    }
}

// MARK: Authentication
extension FirestoreManager {
    // 현재 로그인이 되어 있는지 확인
    func isLoggedIn() -> Bool {
        return !(Auth.auth().currentUser == nil)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("fail Sign Out")
        }
        
    }
}

// MARK: 북마크
extension FirestoreManager {
    // User의 bookmarkedBookstores 의 값 변경 (북마크 버튼 누를 때 호출)
    func updateBookmark(email: String, provider: String, bookmarkedBookstores: [String]) async throws {
        let querySnapshot = try await users.whereField("email", isEqualTo: email).whereField("provider", isEqualTo: provider).getDocuments()
        let document = querySnapshot.documents.first
        try await document?.reference.updateData(["bookmarkedBookstores" : bookmarkedBookstores])
    }
    
    // 유저가 가진 서점 id 값으로 북마크된 서점 fetch
    func fetchBookmarkedBookstores() async throws -> [Bookstore] {
        if isLoggedIn() {
            let user = try await fetchCurrentUser()
            var bookmarkedBookstores = [Bookstore]()
            for index in user.bookmarkedBookstores.indices {
                bookmarkedBookstores.append(try await fetchBookstore(with: user.bookmarkedBookstores[index]))
            }
            
            return bookmarkedBookstores
        } else {
            return []
        }
    }
}

// MARK: 좋아요
extension FirestoreManager {
    // 큐레이션의 likes 업데이트
    func updateLike(bookstoreID: String, likes: [String]) async throws {
        let querySnapshot = try await curations.whereField("bookstoreID", isEqualTo: bookstoreID).getDocuments()
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
