//
//  RegionCell.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//

import UIKit

class RegionCell: UITableViewCell {
    
    static let identifier = "RegionCell"
    static let rowHeight: CGFloat = 104     // Cell 길이
    
    var bookstore: Dummy? {
        didSet {
            configureCell(item: bookstore!)
        }
    }
    
    // MARK: - 프로퍼티
    
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true      // radius를 imageView에 적용
        view.backgroundColor = .lightGray      // 사진 없을 경우 default 색
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let infoStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .leading
        view.axis = .vertical
        view.spacing = 7   // 피그마에 적혀있는 4 적용하니 좁아보임. 7로 적용하니 피그마에 있는 비율과 비슷
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - 메소드
    
    private func setup() {
        [nameLabel, addressLabel].forEach{ infoStackView.addArrangedSubview($0) }
        [photoImageView, infoStackView].forEach{ contentView.addSubview($0) }
    }
    
    private func createLayout() {
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalToConstant: 104),
            photoImageView.heightAnchor.constraint(equalToConstant: 104),
            
            photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            infoStackView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16),
            infoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func configureCell(item: Dummy) {
        nameLabel.text = item.name
        addressLabel.text = item.address
//        photoImageView.image = item.image?[0] ?? nil   // 첫번째 사진이 대표 사진
    }
    
    // MARK: - 라이프 사이클
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
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