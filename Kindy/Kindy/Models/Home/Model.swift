import Foundation

struct Model {
    var curations = [Curation]()
    var bookstores = [Bookstore]()

    var curation = [ViewModel.Item]()

    var featuredBookstores = [ViewModel.Item]()
    var nearbyBookstores = [ViewModel.Item]()
    var bookmarkedBookstores = [ViewModel.Item]()
    var regions: [ViewModel.Item] = [
        .region("전체"),
        .region("서울"),
        .region("경기/인천"),
        .region("강원"),
        .region("충청/대전"),
        .region("경북/대구"),
        .region("전라/광주"),
        .region("경남/울산/부산"),
        .region("제주")
    ]
}
