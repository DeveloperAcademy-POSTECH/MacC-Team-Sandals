//
//  FirestoreManager.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/05.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreManager {
    enum Reference {
        static let db = Firestore.firestore()
        static let bookstores = db.collection("Bookstores")
        static let curations = db.collection("Curations")
    }
    
    // Bookstores 콜렉션의 모든 도큐먼트를 불러오는 함수
    func fetchBookstores() async throws -> [ViewModel.Item] {
        let querySnapshot = try await Reference.bookstores.getDocuments()
        let bookstores = try querySnapshot.documents.map { try $0.data(as: Bookstore.self) }.map { ViewModel.Item.bookstore($0) }
        return bookstores
    }
    
    // Curations 콜렉션의 모든 도큐먼트를 불러오는 함수
    func fetchCurations() async throws -> [ViewModel.Item] {
        let querySnapshot = try await Reference.curations.getDocuments()
        let curations = try querySnapshot.documents.map { try $0.data(as: Curation.self) }.map { ViewModel.Item.curation($0) }
        return curations
    }
    
    // TODO: 서점, 큐레이션 id로 도큐먼트 가져오기(쿼리 대신)
    
    // TODO: 유저 데이터 저장하는 함수 + 유저 struct 만들기
}
