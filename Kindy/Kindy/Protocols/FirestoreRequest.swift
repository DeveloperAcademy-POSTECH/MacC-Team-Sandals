import Foundation

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Firestore와 CRUD를 제공하는 프로토콜.
protocol FirestoreRequest where Response: Codable & Identifiable {
    associatedtype Response

    /// Subcollection에 접근하기 위한  parent collection path.
    var parentCollectionPath: String { get }
    var collectionPath: String { get }
}

extension FirestoreRequest {
    /// Firestore db에 대한 참조.
    var db: Firestore { Firestore.firestore() }
}

// MARK: Collection
extension FirestoreRequest {
    /// Firestore collection에 대한 참조.
    var collectionReference: CollectionReference { db.collection(collectionPath) }

    /// Firestore document에 대한 참조.
    func documentReference(_ documentID: String) -> DocumentReference {
        collectionReference.document(documentID)
    }
}

// MARK: Subcollection
extension FirestoreRequest {
    /// Subcollection에 접근하기 위한  parent collection path.
    var parentCollectionPath: String { "" }

    var parentCollectionReference: CollectionReference { db.collection(parentCollectionPath) }

    /// Firestore subcollection에 대한 참조.
    func subcollectionReference(_ parentDocumentID: String) -> CollectionReference {
        parentCollectionReference.document(parentDocumentID).collection(collectionPath)
    }

    /// Firestore subcollection의 document에 대한 참조.
    func subdocumentReference(
        _ parentDocumentID: String,
        _ childDocumentID: String
    ) -> DocumentReference {
        subcollectionReference(parentDocumentID).document(childDocumentID)
    }
}

extension FirestoreRequest {
    /// 모든 도큐먼트 fetch.
    func fetch() async throws -> [Response] {
        let querySnapshot = try await collectionReference.getDocuments()
        let responses = try querySnapshot.documents.map { try $0.data(as: Response.self) }
        return responses
    }

    /// 도큐먼트 id로 특정 도큐먼트만 fetch.
    func fetch(with documentID: String) async throws -> Response {
        try await documentReference(documentID).getDocument(as: Response.self)
    }

    /// 도큐먼트 추가.
    func add(_ document: Response) throws {
        try documentReference(document.id as? String ?? UUID().uuidString).setData(from: document)
    }

    /// id 값으로 특정 도큐먼트 삭제.
    func delete(_ documentID: String) async throws {
        try await documentReference(documentID).delete()

        if Response.self == Curation.self {
            try await UserManager().deleteAllCommentedCuration(curationID: documentID)
        }
    }
}
