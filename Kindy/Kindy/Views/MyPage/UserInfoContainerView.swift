//
//  UserInfoContainerView.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/15.
//

import UIKit

final class UserInfoContainerView: UIView {
    
    // MARK: Properties
    var user: User? {
        didSet {
            nicknameLabel.text = user?.nickName
        }
    }
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nicknameEditButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nicknameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nicknameLabel, nicknameEditButton])
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: padding16, bottom: 0, right: padding16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "kindyLightGray3")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bookmarkedBookstoreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor(named: "kindyLightGray3")
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var myWritingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "text.book.closed.fill"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor(named: "kindyLightGray3")
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
    
    lazy var myActivitiesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor(named: "kindyLightGray3")
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var userInfoContainerStackView: UIStackView = {
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
        backgroundColor = .white
        addSubview(userInfoContainerStackView)
        
        setupFixedLayout()
        
        NSLayoutConstraint.activate([
            userInfoContainerStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding24),
            userInfoContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding16),
            userInfoContainerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding16),
            userInfoContainerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding24),
        ])
        
        clipsToBounds = true
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "kindyLightGray2")?.cgColor
    }
    
    private func setupFixedLayout() {
        bookmarkedBookstoreButton.layer.cornerRadius = 60 / 2
        myWritingButton.layer.cornerRadius = 60 / 2
        myActivitiesButton.layer.cornerRadius = 60 / 2
        
        NSLayoutConstraint.activate([
            nicknameStackView.heightAnchor.constraint(equalToConstant: 25),
            
            divider.widthAnchor.constraint(equalToConstant: 326),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            nicknameEditButton.widthAnchor.constraint(equalToConstant: 24),
            
            bookmarkedBookstoreButton.widthAnchor.constraint(equalToConstant: 60),
            bookmarkedBookstoreButton.heightAnchor.constraint(equalToConstant: 60),
            
            myWritingButton.widthAnchor.constraint(equalToConstant: 60),
            myWritingButton.heightAnchor.constraint(equalToConstant: 60),
            
            myActivitiesButton.widthAnchor.constraint(equalToConstant: 60),
            myActivitiesButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
}
