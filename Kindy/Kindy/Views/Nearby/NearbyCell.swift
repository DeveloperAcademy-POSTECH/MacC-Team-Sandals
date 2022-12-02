//
//  NearbyCell.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/20.
//

import UIKit

final class NearbyCell: UITableViewCell {

    static let reuseID = "NearMeListCell"
    static let rowHeight: CGFloat = 136     // Cell 길이
    
    var bookstore: Bookstore? {
        didSet {
            configureCell(item: bookstore!)
        }
    }
    
    // MARK: - Cell 프로퍼티
    
    // 서점 사진
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 104),
            imageView.heightAnchor.constraint(equalToConstant: 104)
        ])
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true      // radius를 imageView에 적용
        imageView.backgroundColor = .kindyLightGray      // 사진 없을 경우 default 색
        
        return imageView
    }()

    // 서점 이름
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline

        return label
    }()
    
    // 서점 상세 주소
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .body2
        label.textColor = .kindyGray
        label.text = ""
        
        return label
    }()
    
    // 서점까지의 거리
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .body1
        label.textColor = .kindyPrimaryGreen
        label.text = ""
        
        return label
    }()
    
    // 레이블들 감싸는 stack
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 7   // 피그마에 적혀있는 4 적용하니 좁아보임. 7로 적용하니 피그마에 있는 비율과 비슷
        stack.alignment = .leading
        
        return stack
    }()
    
    // MARK: - Cell 메소드
    
    private func setup() {
        [photoImageView, infoStackView].forEach { contentView.addSubview($0) }
        [nameLabel, addressLabel, distanceLabel].forEach { infoStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            infoStackView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16),
            infoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureCell(item: Bookstore) {
        nameLabel.text = item.name
        addressLabel.text = item.address
        distanceLabel.text = item.distance > 1000 ? "\(item.distance / 1000)km" : "\(item.distance)m"
    }
    
    // MARK: - 라이프 사이클
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        nameLabel.text = nil
        distanceLabel.text = nil
    }
}
