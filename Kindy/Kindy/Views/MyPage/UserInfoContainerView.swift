//
//  UserInfoContainerView.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/15.
//

import UIKit

final class UserInfoContainerView: UIView {
    
    // MARK: Properties
    private let padding16: CGFloat = 16
    private let padding24: CGFloat = 24
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "몇글자까지가능할까요"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nicknameEditButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nicknameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nicknameLabel, nicknameEditButton])
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "kindyLightGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bookmarkedBookstoreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor(named: "kindyLightGray")
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let bookmarkedBookstoreLabel: UILabel = {
        let label = UILabel()
        label.text = "북마크 한 서점"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bookmarkedBookstoreStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bookmarkedBookstoreButton, bookmarkedBookstoreLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let myWritingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "text.book.closed.fill"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor(named: "kindyLightGray")
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let myWritingLabel: UILabel = {
        let label = UILabel()
        label.text = "내 글"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var myWritingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [myWritingButton, myWritingLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let myActivitiesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor(named: "kindyLightGray")
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let myActivitiesLabel: UILabel = {
        let label = UILabel()
        label.text = "활동 내역"
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var myActivitiesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [myActivitiesButton, myActivitiesLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var infoButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bookmarkedBookstoreStackView, myWritingStackView, myActivitiesStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
//        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nicknameStackView, divider, infoButtonStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func setupUI() {
        addSubview(containerStackView)
        
        setupFixedLayout()
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding24),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding16),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding16),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding24),
        ])
    }
    
    private func setupFixedLayout() {
        bookmarkedBookstoreButton.layer.cornerRadius = 60 / 2
        myWritingButton.layer.cornerRadius = 60 / 2
        myActivitiesButton.layer.cornerRadius = 60 / 2
        
        NSLayoutConstraint.activate([
            nicknameStackView.heightAnchor.constraint(equalToConstant: 25),
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            nicknameEditButton.widthAnchor.constraint(equalToConstant: 20),
            nicknameEditButton.heightAnchor.constraint(equalToConstant: 20),
            
            bookmarkedBookstoreButton.widthAnchor.constraint(equalToConstant: 60),
            bookmarkedBookstoreButton.heightAnchor.constraint(equalToConstant: 60),
            
            myWritingButton.widthAnchor.constraint(equalToConstant: 60),
            myWritingButton.heightAnchor.constraint(equalToConstant: 60),
            
            myActivitiesButton.widthAnchor.constraint(equalToConstant: 60),
            myActivitiesButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc func buttonTapped() {
        print("DEBUG: Button Tapped...")
    }
    
}
