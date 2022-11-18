//
//  TryLoginContainerView.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/16.
//

import UIKit

final class TryLoginContainerView: UIView {
    
    // MARK: Properties
    private let tryLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 후 킨디를 보다 더 즐겨보세요!"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // TODO: divider 안보임
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "kindyLightGray3")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인 하러가기", for: .normal)
        button.setTitleColor(UIColor(named: "kindyPrimaryGreen"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setUnderline()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setUnderline()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tryLogincontainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tryLoginLabel, divider, signInButton, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = padding16
        stackView.alignment = .center
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
        addSubview(tryLogincontainerStackView)
        
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            tryLogincontainerStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding24),
            tryLogincontainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding16),
            tryLogincontainerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding16),
            tryLogincontainerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding24),
        ])
    }
    
}
