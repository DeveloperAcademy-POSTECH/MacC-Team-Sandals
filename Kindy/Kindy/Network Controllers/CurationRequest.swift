//
//  CurationRequest.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/21.
//


import UIKit
import FirebaseFirestoreSwift
import FirebaseStorage

struct CurationRequest: FirestoreRequest {
    typealias Response = Curation
    let collectionPath = CollectionPath.curations
}

extension CurationRequest {
    /// 큐레이션의 likes 업데이트
    func updateLike(curationID: String, likes: [String]) async throws {
        let document = db.collection(collectionPath).document(curationID)
        try await document.updateData(["likes" : likes])
    }
    
    /// 큐레이션 댓글 수 업데이트
    func updateCommentCount(curationID: String, count: Int) async throws {
        let document = db.collection(collectionPath).document(curationID)
        try await document.updateData(["commentCount" : count])
    }
}

extension CurationRequest {
    func uploadImage(image: UIImage, pathRoot: String, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        
        let firebaseReference = Storage.storage().reference().child("\(pathRoot)/\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { (url, _) in
                guard let url = url else { return }
                completion(url.absoluteString)
            }
        }
    }
    
    func deleteImage(url: String) throws {
        let storage = Storage.storage()
        let httpsReference = storage.reference(forURL: url)
        httpsReference.delete{ error in
            if let error = error {
                print("error \(error)")
            } else {
                print("delete Success")
            }
        }
    }
}

/// 마이페이지에서 사용하는 CurationRequest
extension CurationRequest {
    
    // 내가 작성한 큐레이션
    func fetchMyCuration(userID: String) async throws -> [Curation] {
        let querySnapShot = try await db.collection(collectionPath).whereField("userID", isEqualTo: userID).getDocuments()
        let document = try querySnapShot.documents.map { try $0.data(as: Curation.self) }
        return document.reversed()
    }
    
    // 좋아요 한 큐레이션
    func fetchLikeCurations(userID: String) async throws -> [Curation] {
        let querySnapshot = try await db.collection(collectionPath).whereField("likes", arrayContains: userID).getDocuments()
        let document = try querySnapshot.documents.map { try $0.data(as: Curation.self) }
        return document.reversed()
    }
    
    // 댓글 단 큐레이션
    func fetchCommentedCurations(userID: String) async throws -> [Curation] {
        // 현재 유저의 document 데이터를 가져와서
        let documentSnapshot = try await db.collection(CollectionPath.users).document(userID).getDocument()
        let user = try documentSnapshot.data(as: User.self)
        var commentedCurations: [Curation] = []
        
        // 유저가 댓글 단 글을 하나씩 순회하며 각 큐레이션을 commentedCurations에 추가
        for i in user.commentedCurations.indices {
            let index = (user.commentedCurations.count-1-i)
            // 최신 댓글 순서로 append
            let curationID = user.commentedCurations[index]
            let querysnapShot = try await db.collection(collectionPath).whereField("id", isEqualTo: curationID).getDocuments()
            let curation = try querysnapShot.documents.map { try $0.data(as: Curation.self) }
            
            guard let curation = curation.first else { return commentedCurations }
            
            commentedCurations.append(curation)
        }
        
        return commentedCurations
    }
    
}
