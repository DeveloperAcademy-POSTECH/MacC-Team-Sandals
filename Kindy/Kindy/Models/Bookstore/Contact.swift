import Foundation

struct Contact {
    let telNumber: String?
    let emailAddress: String?
    let instagramURL: String?
}

extension Contact: Codable { }

extension Contact: Hashable { }
