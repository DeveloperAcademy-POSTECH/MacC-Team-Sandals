import Foundation

// 서점의 위도와 경도를 표현하는 구조체
struct Location {
    let latitude: Double
    let longitude: Double
}

extension Location: Codable { }

extension Location: Hashable { }
