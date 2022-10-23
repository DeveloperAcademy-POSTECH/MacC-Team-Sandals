//
//  BookmarkCollectionViewCell.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/10/23.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookMarkCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureCell(_ title: String) {
        titleLabel.text = title
    }
}
