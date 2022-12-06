//
//  EditNicknameView.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/20.
//

import UIKit

final class EditNicknameView: UIView {
    
    // MARK: Properties
    private let nicknameGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "사용하실 닉네임을 입력해주세요 (10자 제한)"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요"
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let textFieldUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "kindyGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(nicknameGuideLabel)
        addSubview(nicknameTextField)
        addSubview(textFieldUnderLine)
        addSubview(warningLabel)
        
        NSLayoutConstraint.activate([
            nicknameGuideLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            nicknameGuideLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding16),
            nicknameGuideLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding16),
            
            nicknameTextField.topAnchor.constraint(equalTo: nicknameGuideLabel.bottomAnchor, constant: 18),
            nicknameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding16),
            nicknameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding16),
            
            textFieldUnderLine.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 10),
            textFieldUnderLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding16),
            textFieldUnderLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding16),
            textFieldUnderLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            warningLabel.topAnchor.constraint(equalTo: textFieldUnderLine.bottomAnchor, constant: 8),
            warningLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding16),
            warningLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding16),
        ])
    }
    
}
