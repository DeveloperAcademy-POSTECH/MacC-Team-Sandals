//
//  SignInView.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/17.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

final class SignInView: UIView {

    // MARK: Properties
    weak var delegate: SignInDelegate?

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "KindyIconBorder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, welcomeLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var loginButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [appleLoginButton, googleLoginButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        setupUI()
        setupSignInButton()
    }

    // MARK: Helpers
    private func setupUI() {
        descriptionLabel.text = "내 손 안의 독립서점"
        welcomeLabel.text = "Kindy에 오신 것을 환영합니다"

        addSubview(iconImageView)
        addSubview(labelStackView)
        addSubview(loginButtonStackView)

        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 180),
            iconImageView.heightAnchor.constraint(equalToConstant: 180),
            iconImageView.bottomAnchor.constraint(equalTo: labelStackView.topAnchor, constant: -32),

            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.sixteen),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.sixteen),

            googleLoginButton.heightAnchor.constraint(equalToConstant: 48),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 48),

            loginButtonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            loginButtonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.sixteen),
            loginButtonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.sixteen),
            loginButtonStackView.heightAnchor.constraint(equalToConstant: 112)
        ])
    }

    private func setupSignInButton() {
        appleLoginButton.addTarget(self, action: #selector(appleSignIn), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
    }

    @objc func appleSignIn() {
        delegate?.appleSignInMethod()
    }

    @objc func googleSignIn() {
        delegate?.googleSignInMethod()
    }

}
