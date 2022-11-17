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
    
    var delegate: SignInDelegate?

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline
        label.textColor = UIColor.kindySecondaryGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline
        label.textColor = UIColor.kindyPrimaryGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        setupAppleSignInButton()
        setupGoogleSignInButton()
        setupLabel()
    }
    
    private func setupLabel() {
        descriptionLabel.text = "내 손 안의 독립서점"
        welcomeLabel.text = "Kindy에 오신 것을 환영합니다"
        addSubview(descriptionLabel)
        addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: appleLoginButton.topAnchor, constant: -56),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: -8)
        ])
    }
    
    private func setupGoogleSignInButton() {
        googleLoginButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
        addSubview(googleLoginButton)
        NSLayoutConstraint.activate([
            googleLoginButton.topAnchor.constraint(equalTo: centerYAnchor, constant: 8),
            googleLoginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            googleLoginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    
    private func setupAppleSignInButton() {
        appleLoginButton.addTarget(self, action: #selector(appleSignIn), for: .touchUpInside)
        addSubview(appleLoginButton)
        NSLayoutConstraint.activate([
            appleLoginButton.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -8),
            appleLoginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            appleLoginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc func googleSignIn() {
        delegate?.googleSignInMethod()
    }
    
    @objc func appleSignIn() {
        delegate?.appleSignInMethod()
    }
    

}
