//
//  RegionCell.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//
import UIKit

final class RegionCell: UITableViewCell {

    static let rowHeight: CGFloat = 104     // Cell 길이
    
    var bookstore: Bookstore? {
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
        view.backgroundColor = .kindyLightGray      // 사진 없을 경우 default 색
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
        label.font = .headline
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .body2
        label.textColor = .kindyGray
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
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor),

            infoStackView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 16),
            infoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    private func configureCell(item: Bookstore) {
        nameLabel.text = item.name
        addressLabel.text = item.address
//        photoImageView.image = item.images?[0]   // 첫번째 사진이 대표 사진
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
