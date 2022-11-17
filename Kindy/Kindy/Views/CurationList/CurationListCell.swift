//
//  CurationListCell.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/11/08.
//

import UIKit

final class CurationListCell: UITableViewCell {
    
    static let rowHeight: CGFloat = 263     // Cell 길이
    
    var curation: Curation? {
        didSet {
            configureCell(item: curation!)
        }
    }
    
    // MARK: - 프로퍼티
    
    let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .kindyLightGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private let titleInfoStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .leading
        view.axis = .vertical
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let leftInfoStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .leading
        view.axis = .horizontal
        view.spacing = 7   // 피그마에 적혀있는 4 적용하니 좁아보임. 7로 적용하니 피그마에 있는 비율과 비슷
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private let rightInfoStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .trailing
        view.axis = .horizontal
        view.spacing = 13   // 피그마에 적혀있는 4 적용하니 좁아보임. 7로 적용하니 피그마에 있는 비율과 비슷
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "좋아요"

        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "댓글"

        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .footnote
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "날짜"

        return label
    }()
    
    private let kinditorLabel: UILabel = {
        let label = UILabel()
        label.font = .footnote
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "킨디터"

        return label
    }()
    
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
//        nameLabel.text = nil
    }
    
    // MARK: - 메소드
    
    private func setup() {
        [likeLabel, commentLabel].forEach{ leftInfoStackView.addArrangedSubview($0) }
        [dateLabel, kinditorLabel].forEach{ rightInfoStackView.addArrangedSubview($0) }
        [titleLabel, subTitleLabel].forEach{ titleInfoStackView.addArrangedSubview($0) }
        [photoImageView, titleInfoStackView, leftInfoStackView, rightInfoStackView].forEach{ contentView.addSubview($0) }
    }

    private func createLayout() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -54),
            
            titleInfoStackView.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 16),
            titleInfoStackView.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 113),
            titleInfoStackView.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -10),

            leftInfoStackView.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 8),
            leftInfoStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 16),
            
            rightInfoStackView.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8),
            rightInfoStackView.centerYAnchor.constraint(equalTo: leftInfoStackView.centerYAnchor)
        ])
    }

    private func configureCell(item: Curation) {
        titleLabel.text = item.title
        subTitleLabel.text = item.subTitle
//        likeLabel.text = "좋아요 \(item.likes.count)개"
        dateLabel.text = "\(item.createdAt!)"
//        kinditorLabel.text = "킨디터 \(item.userID)"
        
        // MARK: 좋아요
        let attributedString = NSMutableAttributedString(string: "")
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "heart")?.withTintColor(.kindySecondaryGreen ?? UIColor())
        
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: " \(item.likes.count)"))
        
        likeLabel.attributedText = attributedString
        
        // MARK: 댓글
        let commentAttributedString = NSMutableAttributedString(string: "")
        
        let commentImageAttachment = NSTextAttachment()
        commentImageAttachment.image = UIImage(systemName: "bubble.left")?.withTintColor(.kindySecondaryGreen ?? UIColor())
        
        commentAttributedString.append(NSAttributedString(attachment: commentImageAttachment))
        commentAttributedString.append(NSAttributedString(string: " 100"))
        
        commentLabel.attributedText = commentAttributedString
        
        // MARK: 킨디터
        let kinditorAttributedString = NSMutableAttributedString(string:"킨디터 백루이")
//        let kinditorAttributedString = NSMutableAttributedString(string:"킨디터 \(item.userID)")

        kinditorAttributedString.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Bold", size: 13), range: NSRange(location: 4,length: 3))
//        kinditorAttributedString.addAttribute(.font, value: UIFont.subhead, range: NSRange(location: 4,length: item.userID.count))
        
        kinditorLabel.attributedText = kinditorAttributedString
    }
}
