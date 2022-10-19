//
//  UIViewController+.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

extension UIViewController {
    func gradientView(bounds: CGRect, colors: [CGColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.9)
        return gradientLayer
    }
}