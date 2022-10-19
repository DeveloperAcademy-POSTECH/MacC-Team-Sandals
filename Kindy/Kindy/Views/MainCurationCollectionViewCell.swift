//
//  MainCurationCollectionViewCell.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/19.
//

import UIKit

// 홈 화면 최상단의 메인 큐레이션 셀
class MainCurationCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MainCurationCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        
        return imageView
    }()
    
    let labelBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.addSubview(labelBackgroundView)
        labelBackgroundView.addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        labelBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            labelBackgroundView.heightAnchor.constraint(equalTo: superview!.heightAnchor, multiplier: 0.38),
            labelBackgroundView.bottomAnchor.constraint(equalTo: superview!.bottomAnchor),
            labelBackgroundView.leadingAnchor.constraint(equalTo: superview!.leadingAnchor),
            labelBackgroundView.trailingAnchor.constraint(equalTo: superview!.trailingAnchor),
            
            titleLabel.widthAnchor.constraint(equalTo: superview!.widthAnchor, multiplier: 0.85),
            titleLabel.heightAnchor.constraint(equalTo: superview!.heightAnchor, multiplier: 0.25),
            titleLabel.centerXAnchor.constraint(equalTo: superview!.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: superview!.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Cell
    // TODO: TempCuration 메인 큐레이션으로 바꿔야함
    func configureCell(_ mainCuration: TempCuration) {
        titleLabel.text = mainCuration.name
    }
}
