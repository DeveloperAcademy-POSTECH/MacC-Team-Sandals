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
        try await documentReference(curationID).updateData(["likes": likes])
    }

    /// 큐레이션 댓글 수 업데이트
    func updateCommentCount(curationID: String, count: Int) async throws {
        try await documentReference(curationID).updateData(["commentCount": count])
    }
}

extension CurationRequest {
    func uploadImage(image: UIImage, pathRoot: String, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)

        let firebaseReference = Storage.storage().reference().child("\(pathRoot)/\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { _, _ in
            firebaseReference.downloadURL { url, _ in
                guard let url else { return }
                completion(url.absoluteString)
            }
        }
    }

    func deleteImage(url: String) throws {
        let storage = Storage.storage()
        let httpsReference = storage.reference(forURL: url)
        httpsReference.delete { error in
            if let error {
                print("error \(error)")
            } else {
                print("delete Success")
            }
        }
    }

    func asyncUploadImage(image: UIImage, pathRoot: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return nil }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)

        let firebaseReference = Storage.storage().reference().child("\(pathRoot)/\(imageName)")
        _ = try await firebaseReference.putDataAsync(imageData, metadata: metaData)
        let url = try await firebaseReference.downloadURL().absoluteString
        return url
    }
}
