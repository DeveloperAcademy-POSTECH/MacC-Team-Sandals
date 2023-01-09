import Foundation

struct Bookstore {
    var id: String = UUID().uuidString
    let images: [String]?
    let name: String
    var address: String
    let description: String
    let contact: Contact
    let businessHour: BusinessHour
    let location: Location
    var distance: Int = 0  // 내 주변 서점과 떨어진 거리(m)
}

extension Bookstore {
    static let error = Bookstore(
        images: nil,
        name: "오류가 발생했어요",
        address: "",
        description: "",
        contact: Contact(telNumber: "", emailAddress: "", instagramURL: ""),
        businessHour: BusinessHour(),
        location: Location(latitude: 37.33, longitude: 126.59)
    )

    // 짧은 주소
    var shortAddress: String {
        address.components(separatedBy: " ")[0] + " " + address.components(separatedBy: " ")[1]
    }
}

extension Bookstore: Codable { }

extension Bookstore: Hashable { }

extension Bookstore: Identifiable { }
