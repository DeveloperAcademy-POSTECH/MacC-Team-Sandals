//
//  SignUpView.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/17.
//

import UIKit

class SignUpView: UIView {
    
    var provider: String?
    var email: String?
    var nickName: String = ""
    var nickNameArray: [String]?
    
    weak var delegate: SignUpDelegate?
    
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.footnote
        label.textColor = UIColor.kindyGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let underLineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let isAlreadyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.footnote
        label.textColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkPolicyView: CheckPolicyUIView = {
        let view = CheckPolicyUIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        
        button.backgroundColor = UIColor.kindySecondaryGreen
        button.setBackgroundColor(UIColor.kindySecondaryGreen!, for: .normal)
        button.setBackgroundColor(.white, for: .selected)
        button.setBackgroundColor(UIColor.kindyLightGray!, for: .disabled)
        button.clipsToBounds = true
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
        setupDescriptionLabel()
        setupNickNameTextField()
        setupUnderLineView()
        setupIsAlreadyLabel()
        setupPolicyView()
        setupSignIn()
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = "(필수) 사용하실 닉네임을 입력해주세요"
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 123),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        ])
    }
    
    private func setupNickNameTextField() {
        nickNameTextField.delegate = self
        nickNameTextField.placeholder = "닉네임을 입력해주세요"
        addSubview(nickNameTextField)
        NSLayoutConstraint.activate([
            nickNameTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 23),
            nickNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nickNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    private func setupUnderLineView() {
        addSubview(underLineView)
        NSLayoutConstraint.activate([
            underLineView.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 15),
            underLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            underLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            underLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupIsAlreadyLabel() {
        isAlreadyLabel.text = "이미 사용 중인 닉네임입니다."
        isAlreadyLabel.alpha = 0
        addSubview(isAlreadyLabel)
        NSLayoutConstraint.activate([
            isAlreadyLabel.topAnchor.constraint(equalTo: underLineView.bottomAnchor, constant: 8),
            isAlreadyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func setupPolicyView() {
        checkPolicyView.delegate = delegate
        addSubview(checkPolicyView)
        NSLayoutConstraint.activate([
            checkPolicyView.topAnchor.constraint(equalTo: underLineView.bottomAnchor, constant: 56),
            checkPolicyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            checkPolicyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            checkPolicyView.heightAnchor.constraint(equalToConstant: 124)
        ])
    }
    
    private func setupSignIn() {
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.isEnabled = false
        addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: checkPolicyView.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc func signUp() {
        delegate?.signUpDelegate()
    }
    
    

}


extension SignUpView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        delegate?.textFieldAction(newText)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.textFieldAction("")
        return true
    }

}
