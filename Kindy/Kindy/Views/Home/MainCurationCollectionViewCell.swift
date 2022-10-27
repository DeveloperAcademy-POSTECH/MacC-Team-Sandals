//
//  MainCurationCollectionViewCell.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/19.
//

import UIKit

// 홈 화면 최상단의 메인 큐레이션 셀
final class MainCurationCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let labelBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.opacity = 0.8
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.backgroundColor = UIColor(red: 0.149, green: 0.258, blue: 0.232, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        return label
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(labelBackgroundView)
        addSubview(titleStack)
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            labelBackgroundView.heightAnchor.constraint(equalToConstant: 99),
            labelBackgroundView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            labelBackgroundView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            labelBackgroundView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            titleStack.leadingAnchor.constraint(equalTo: labelBackgroundView.leadingAnchor, constant: 16),
            titleStack.trailingAnchor.constraint(equalTo: labelBackgroundView.trailingAnchor, constant: 16),
            titleStack.centerYAnchor.constraint(equalTo: labelBackgroundView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Cell
    func configureCell(_ mainCuration: Curation) {
        titleLabel.text = mainCuration.title
        subTitleLabel.text = mainCuration.subTitle
        imageView.image = UIImage(named: mainCuration.mainImage)
    }
}
