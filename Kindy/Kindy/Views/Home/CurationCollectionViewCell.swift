//
//  CurationCollectionViewCell.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/19.
//

import UIKit

// 킨디터 픽 섹션의 큐레이션 셀
final class CurationCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray2
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        addSubview(labelBackgroundView)
        addSubview(titleLabel)
        addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            labelBackgroundView.heightAnchor.constraint(equalToConstant: 44),
            labelBackgroundView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            labelBackgroundView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            labelBackgroundView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            
            numberLabel.widthAnchor.constraint(equalToConstant: 55),
            numberLabel.heightAnchor.constraint(equalToConstant: 20),
            numberLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            numberLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Cell
    // TODO: TempCuration 나중에 바꿔야함
    func configureCell(_ curation: Curation, indexPath: IndexPath, numberOfItems: Int) {
        titleLabel.text = curation.subTitle
        numberLabel.text = "\(indexPath.item + 1) / \(numberOfItems)"
        imageView.image = UIImage(named: curation.mainImage)
    }
}
