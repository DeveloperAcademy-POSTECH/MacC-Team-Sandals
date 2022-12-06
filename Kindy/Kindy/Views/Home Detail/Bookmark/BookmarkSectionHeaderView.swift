//
//  BookmarkSectionHeaderView.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/03.
//

import UIKit

class BookmarkSectionHeaderView: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.footnote
        label.textColor = UIColor.kindyGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleLabel()
        
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setTitle(_ count: Int) {
        titleLabel.text = "총 \(count)개"
    }
        
}
