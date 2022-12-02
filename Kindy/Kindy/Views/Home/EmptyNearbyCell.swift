//
//  EmptyNearbyCell.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/23.
//

import UIKit

// 내 주변 서점 섹션이 비었을때의 셀
final class EmptyNearbyCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .body2
        label.text = "현재 계신 곳 주변에 독립서점이 없어요"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
