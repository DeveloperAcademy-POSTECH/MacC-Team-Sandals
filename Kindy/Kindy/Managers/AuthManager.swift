//
//  AuthManager.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/09.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthManager {
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    // User Login 확인 가능
    func isLogined() -> Bool {
        if user == nil {
            return false
        } else {
            return true
        }
    }
    // user.email 로 users 도큐먼트 가져오는 로직하여 User 를 리턴하는 함수 부탁드립니다.
//    func getUserData() -> User? {
//        
//        var returnUser: User?
//        
//        db.collection("users").document(user?.email ?? "").getDocument{ (document, error) in
//            if let document = document, document.exists {
//                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                    print("Document data: \(dataDescription)")
//                returnUser = User(id: String(describing: dataDescription["email"]), nickName: String(describing: dataDescription["nickName"]), bookmarkedBookstores: [])
//                }
//        }
//        return returnUser
//    }
}
