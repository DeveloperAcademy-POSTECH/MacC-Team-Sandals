import Foundation

/// 서점의 영업 시간.
struct BusinessHour {
    var monday: String?
    var tuesday: String?
    var wednesday: String?
    var thursday: String?
    var friday: String?
    var saturday: String?
    var sunday: String?
    var notice: String?
}

extension BusinessHour: Codable { }

extension BusinessHour: Hashable { }
