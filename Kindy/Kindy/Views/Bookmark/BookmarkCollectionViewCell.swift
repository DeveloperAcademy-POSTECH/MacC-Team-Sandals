//
//  BookmarkCollectionViewCell.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/10/23.
//

import UIKit

class BookmarkCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookMarkCollectionViewCell"
    
    private let uiView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .gray
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let addrLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        button.tintColor = UIColor(named: "kindyGreen")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
     }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(uiView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(bookmarkButton)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        let height = (frame.width - 32) * 1.0558
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            uiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            uiView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            uiView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        
        setupButtonUI()
        setupLabelStackView()
    }
    
    func setupButtonUI() {
        NSLayoutConstraint.activate([
            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            bookmarkButton.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 24),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 23),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
    }
    
    func setupLabelStackView() {
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(addrLabel)
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 16),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            labelStackView.trailingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor),
            
        ])
    }
    
//    func setupTotalStackView() {
//        totalStackView.addArrangedSubview(labelStackView)
//        totalStackView.addArrangedSubview(bookmarkButton)
//        NSLayoutConstraint.activate([
//            totalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
//            totalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
//            totalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//            totalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
//        ])
//    }
    
    
    func configureCell(_ title: String) {
        titleLabel.text = title
        addrLabel.text = "포항시 남구"
    }
}
