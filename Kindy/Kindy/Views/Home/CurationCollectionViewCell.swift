//
//  CurationCollectionViewCell.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/19.
//

import UIKit

// 킨디터 픽 섹션의 큐레이션 셀
final class CurationCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CurationCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // TODO: label의 corner radius는 어떻게 수정하지? 아니면 백그라은드 뷰를 따로 만들어야하나
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 8
        label.backgroundColor = .black
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 326),
            imageView.heightAnchor.constraint(equalToConstant: 152),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16),
            
            numberLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            numberLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Cell
    // TODO: TempCuration 나중에 바꿔야함
    func configureCell(_ curation: TempCuration, indexPath: IndexPath, numberOfItems: Int) {
        titleLabel.text = curation.title
        numberLabel.text = "\(indexPath.item + 1) / \(numberOfItems)"
    }
}
