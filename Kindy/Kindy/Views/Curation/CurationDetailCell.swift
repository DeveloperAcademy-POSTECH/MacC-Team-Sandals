//
//  CurationDetailCell.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

protocol DynamicCell: AnyObject {
    func calHeight() -> CGFloat
}

final class CurationDetailCell: UICollectionViewCell {
    
    var cellHeight: CGFloat = 0
    
    private lazy var spacingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "testImage")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 15)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.adjustsFontSizeToFitWidth = true
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
        self.addSubview(descriptionLabel)
        self.addSubview(spacingView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
 
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: spacingView.topAnchor, constant: -16),
            
            spacingView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            spacingView.heightAnchor.constraint(equalToConstant: 20),
            spacingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            spacingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    
    func configure(imageWithText: (String, String)) {
        imageView.image = UIImage(named: imageWithText.0)
        descriptionLabel.text = imageWithText.1
    }
}

extension CurationDetailCell: DynamicCell {
    func calHeight() -> CGFloat {
        return [descriptionLabel, imageView].map { view in
            view.frame.size.height
        }.reduce(into: 0) { partialResult, CGFloat in
            partialResult += CGFloat
        }
    }
}
