//
//  UIScrollView+.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/12/04.
//

import UIKit

// MARK: 동적 셀 높이 변화에 따른 ScrollView의 Scroll 높이를 조정해주는 Extension > 리팩토링 시 extension으로 빼기
extension UIScrollView {
    func updateContentSize() {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
        // 계산된 크기로 컨텐츠 사이즈 설정
        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height+50)
    }

    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero

        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }

        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }

    public func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }

    public func scrollToTextView(_ offset: CGFloat, height: CGFloat, keyboardHeight: CGFloat) {
        let bottomOffset = CGPoint(x: 0, y: offset - (height - keyboardHeight))
        setContentOffset(bottomOffset, animated: true)
    }
}
