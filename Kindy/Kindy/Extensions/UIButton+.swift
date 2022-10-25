//
//  UIButton+.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//

import UIKit

// button에 underline 주기 위한 extension
extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: title.count))
        setAttributedTitle(attributedString, for: .normal)
    }
}
