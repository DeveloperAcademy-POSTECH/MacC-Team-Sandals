//
//  HomeSearchCell.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/23.
//

import UIKit

final class HomeSearchCell: UITableViewCell {

    static let identifier = "HomeSearchCell"
    static let rowHeight: CGFloat = 96
    
    var bookstore: Dummy? {
        didSet {
            configureCell(item: bookstore!)
        }
    }
    
    // MARK: - 프로퍼티
    
    private var photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true      // radius를 imageView에 적용
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - 메소드
    
    private func createLayout() {
        [photoImageView, nameLabel].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16)
        ])
    }
    
    private func configureCell(item: Dummy) {
        nameLabel.text = item.name
    }
    
    // MARK: - 라이프 사이클
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        createLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        nameLabel.text = nil
    }
}
