//
//  NearbyCell.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/20.
//

import UIKit

class NearbyCell: UITableViewCell {

    static let reuseID = "NearMeListCell"
    static let rowHeight: CGFloat = 136     // Cell 길이
    
    var bookstore: Dummy? {
        didSet {
            configureCell(item: bookstore!)
        }
    }
    
    // MARK: - Cell 프로퍼티
    
    // 서점 사진
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 104),
            imageView.heightAnchor.constraint(equalToConstant: 104)
        ])
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true      // radius를 imageView에 적용
        imageView.backgroundColor = .lightGray      // 사진 없을 경우 default 색
        
        return imageView
    }()

    // 서점 이름
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.text = ""

        return label
    }()
    
    // 서점 상세 주소
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
        label.text = ""
        
        return label
    }()
    
    // 서점까지의 거리
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = UIColor(red: 0.173, green: 0.459, blue: 0.355, alpha: 1)
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
            infoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func configureCell(item: Dummy) {
        nameLabel.text = item.name
        addressLabel.text = item.address
        distanceLabel.text = "\(item.meterDistance!)m"
//        photoImageView.image = item.image?[0] ?? nil   // 첫번째 사진이 대표 사진
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
