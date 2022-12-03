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
    // 큐레이션의 likes 업데이트
    func updateLike(curationID: String, likes: [String]) async throws {
        let document = db.collection(collectionPath).document(curationID)
        try await document.updateData(["likes" : likes])
    }
    
    // 큐레이션 댓글 수 업데이트
    func updateCommentCount(curationID: String, count: Int) async throws {
        let document = db.collection(collectionPath).document(curationID)
        try await document.updateData(["commentCount" : count])
    }
}

extension CurationRequest {
    func createComment(curationID: String, userID: String ,content: String, count: Int) async throws {
        let comment = Comment(id: UUID().uuidString, userID: userID, content: content, createdAt: Date())
        try await db.collection(collectionPath).document(curationID).collection("Comment").document(comment.id).setData(["id" : comment.id, "userID" : comment.userID, "content" : comment.content, "createdAt" : comment.createdAt])
        
        try await updateCommentCount(curationID: curationID, count: count)
    }
    
    func deleteComment(curationID: String, commentID: String, count: Int) async throws {
        try await db.collection(collectionPath).document(curationID).collection("Comment").document(commentID).delete()
        try await updateCommentCount(curationID: curationID, count: count)
    }
    
    func uploadCurationImage(image: UIImage, pathRoot: String, completion: @escaping (String?) -> Void) {
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
    
    func deleteCurationImage(url: String) throws {
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
