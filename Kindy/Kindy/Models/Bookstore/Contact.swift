import Foundation

/// 서점의 연락처.
struct Contact {
    let telNumber: String?
    let emailAddress: String?
    let instagramURL: String?
}

extension Contact: Codable { }

extension Contact: Hashable { }
