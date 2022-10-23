//
//  UIView+.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

extension UIView {
    func gradientView(bounds: CGRect, colors: [CGColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.25)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        return gradientLayer
    }
}
