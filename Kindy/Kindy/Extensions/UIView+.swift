//
//  UIView+.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/27.
//

import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

extension UIView {
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
