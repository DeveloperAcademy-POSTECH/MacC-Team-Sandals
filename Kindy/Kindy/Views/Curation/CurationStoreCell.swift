//
//  TestCurationCell.swift
//  Kindy
//
//  Created by rbwo on 2022/10/23.
//

import UIKit

class CurationStoreCell: UICollectionViewCell {
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .kindyLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .headline
        view.numberOfLines = 0
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.textColor = .secondaryLabel
        view.font = .body2
        view.numberOfLines = 0
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)

        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addSubview(imageView)
        self.addSubview(lineView)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 72),
            imageView.heightAnchor.constraint(equalToConstant: 72),
            
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            lineView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
        ])
    }
    
    func configure(curation: Curation) {
        imageView.image = UIImage(named: curation.mainImage)
        titleLabel.text = curation.bookStore.name
        descriptionLabel.text = curation.bookStore.shortAddress
    }
}
