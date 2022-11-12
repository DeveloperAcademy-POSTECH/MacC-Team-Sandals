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

// MARK: - 큐레이션

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

// MARK: -  서점

extension FirestoreManager {
    // 모든 서점 fetch
    func fetchBookstores() async throws -> [Bookstore] {
//        print("beforebefore")
        let querySnapshot = try await bookstores.getDocuments()
//        print("before \(querySnapshot.documents.first?.data() )")
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

// MARK: -  유저

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
    func fetchCurrentUser() async throws -> User {
        let auth = Auth.auth().currentUser
        let email = auth?.email
        if email!.contains("@gmail.com") {
            let user = try await users.document(email ?? "").getDocument(as: User.self)
            return user
        } else {
            let user = try await users.document(Auth.auth().currentUser?.uid ?? "").getDocument(as: User.self)
            return user
        }
        
        
        
    }
    
    func deleteUser() {
        print("deleteUser call")
        users.document(Auth.auth().currentUser?.uid ?? "al").delete()
        Auth.auth().currentUser?.delete() { _ in
            print("delete User Success")
        }
    }
}

// MARK: - 이미지

extension FirestoreManager {
    enum ImageRequestError: Error {
        case couldNotInitializeFromData
        case imageDataMissing
    }
    
    func fetchImage(with url: String?) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: URL(string: url ?? "")!)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ImageRequestError.imageDataMissing
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageRequestError.couldNotInitializeFromData
        }
        
        return image
    }
}



// MARK: Authentication
extension FirestoreManager {
    
    // 현재 로그인이 되어 있는지 확인하는 함수
    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser == nil ? false : true
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("fail Sign Out")
        }
        
    }
}


// MARK: Bookmark
extension FirestoreManager {
    // User의 bookmarkedBookstores 의 값을 바꿔주는 함수(북마크 버튼을 누를 때 호출)
    // 추후 추가가 되었는지 안되었는지 확인할 수 있게 return true를 해줄 수 있으면 좋을 듯.....
    func updateBookmark(email: String, provider: String, bookmarkedBookstores: [String]) async throws {
        users.whereField("email", isEqualTo: email).whereField("provider", isEqualTo: provider).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                let document = querySnapshot!.documents.first
                document?.reference.updateData([
                    "bookmarkedBookstores" : bookmarkedBookstores
                ])
                
            }
        }
    }
}
