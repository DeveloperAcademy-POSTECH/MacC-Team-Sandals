import Foundation

/// 유저.
struct User {
    let email: String
    let nickName: String

    /// 회원가입 경로 (gmail, apple).
    let provider: String

    /// 유저가 북마크에 등록한 서점들의 배열.
    var bookmarkedBookstores: [String]

    /// 유저가 댓글 단 큐레이션들의 배열.
    var commentedCurations: [String]
}

extension User: Codable { }

extension User: Identifiable {
    var id: String { email + nickName }
}
