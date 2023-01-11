import Foundation

/// 홈 화면의 섹션 헤더를 눌렀을때 상세페이지로 넘어가기 위한 델리게이트.
protocol SectionHeaderDelegate: AnyObject {
    func segueWithSectionIndex(_ sectionIndex: Int)
}
