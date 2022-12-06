//
//  ImageCarouselCollectionViewCell.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/10/23.
//

import UIKit

class ImageCarouselCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupUI() {
        let imageViewConstraint = [
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        NSLayoutConstraint.activate(imageViewConstraint)
    }
    
    public func configureCell(image: UIImage) {
        imageView.image = image
    }
}


