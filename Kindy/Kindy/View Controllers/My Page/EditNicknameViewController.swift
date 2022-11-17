//
//  EditNicknameViewController.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/16.
//

import UIKit

final class EditNicknameViewController: UIViewController {
    
    // MARK: Properties
    private let nicknameGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "사용하실 닉네임을 입력해주세요 (10자 제한)"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let textFieldUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "kindyGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        nicknameTextField.delegate = self
        navigationController?.title = "내 정보 수정"
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    // MARK: Helpers
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(nicknameGuideLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(textFieldUnderLine)
        view.addSubview(warningLabel)
        
        NSLayoutConstraint.activate([
            nicknameGuideLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            nicknameGuideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding16),
            nicknameGuideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding16),
            
            nicknameTextField.topAnchor.constraint(equalTo: nicknameGuideLabel.bottomAnchor, constant: 18),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding16),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding16),
            
            textFieldUnderLine.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 10),
            textFieldUnderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding16),
            textFieldUnderLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding16),
            textFieldUnderLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            warningLabel.topAnchor.constraint(equalTo: textFieldUnderLine.bottomAnchor, constant: 8),
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding16),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding16),
        ])
    }
    
}

// MARK: Extensions
// MARK: UITextFieldDelegate
extension EditNicknameViewController: UITextFieldDelegate {
    
    // 텍스트 필드 글자 내용이 (한글자 한글자) 입력되거나 지워질때 호출되고 허락 여부 판단
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(#function)
        return true
    }
    
    // 엔터 누르면 일단 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nicknameTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nicknameTextField.resignFirstResponder()
    }
}
