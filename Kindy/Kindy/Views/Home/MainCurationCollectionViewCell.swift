//
//  MainCurationCollectionViewCell.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/19.
//

import UIKit

// 홈 화면 최상단의 메인 큐레이션 셀
final class MainCurationCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MainCurationCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let labelBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.opacity = 0.8
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.backgroundColor = .systemGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(labelBackgroundView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            labelBackgroundView.heightAnchor.constraint(equalToConstant: 99),
            labelBackgroundView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            labelBackgroundView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            labelBackgroundView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            titleLabel.widthAnchor.constraint(equalTo: labelBackgroundView.widthAnchor, multiplier: 0.85),
            titleLabel.heightAnchor.constraint(equalTo: labelBackgroundView.heightAnchor, multiplier: 0.25),
            titleLabel.centerXAnchor.constraint(equalTo: labelBackgroundView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: labelBackgroundView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Cell
    // TODO: TempCuration 나중에 바꿔야함
    func configureCell(_ mainCuration: TempCuration) {
        titleLabel.text = mainCuration.title
    }
}
