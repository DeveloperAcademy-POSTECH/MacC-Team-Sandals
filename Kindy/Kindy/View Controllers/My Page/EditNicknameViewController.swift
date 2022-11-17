//
//  EditNicknameViewController.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/16.
//

import UIKit

final class EditNicknameViewController: UIViewController {
    
    // MARK: Properties
    private let firestoreManager = FirestoreManager()
    private var userNicknameRequestTask: Task<Void, Never>?
    
    private lazy var navigationEditButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(editButtonTapped))
        button.tintColor = UIColor(named: "kindyGray2")
        button.isEnabled = false
        return button
    }()
    
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
        navigationItem.rightBarButtonItem = navigationEditButton
        navigationController?.navigationBar.topItem?.title = "내 정보 수정"
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
    
    // MARK: Actions
    @objc func editButtonTapped() {
//        firestoreManager.editNickname(nicknameTextField.text)
        navigationController?.popViewController(animated: true)
        
    }
}

// MARK: Extensions
// MARK: UITextFieldDelegate
extension EditNicknameViewController: UITextFieldDelegate {
    
    // 텍스트필드 입력될 때마다 호출
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(#function)
        
        let maxLength = 10
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        let currentTextFieldString = newString as String
        
        if currentTextFieldString.count == 0 {
            textFieldUnderLine.backgroundColor = UIColor(named: "kindyGray")
            warningLabel.text = ""
            navigationEditButton.tintColor = UIColor(named: "kindyGray2")
            navigationEditButton.isEnabled = false
        } else {
            userNicknameRequestTask?.cancel()

            userNicknameRequestTask = Task {
                guard let result = try? await firestoreManager.isExistingNickname(newString as String) else { return }
                if !result {
                    textFieldUnderLine.backgroundColor = UIColor(named: "kindyGray")
                    warningLabel.text = "사용 가능한 닉네임입니다."
                    warningLabel.textColor = .black
                    navigationEditButton.tintColor = .black
                    navigationEditButton.isEnabled = true
                } else {
                    textFieldUnderLine.backgroundColor = .red
                    warningLabel.text = "이미 사용 중인 닉네임입니다."
                    warningLabel.textColor = .red
                    navigationEditButton.tintColor = UIColor(named: "kindyGray2")
                    navigationEditButton.isEnabled = false
                }
                userNicknameRequestTask = nil
            }
        }
        return newString.length <= maxLength
    }
    
    // 리턴 누르면 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nicknameTextField.resignFirstResponder()
        return true
    }
    
    // 키보드 외 영역 터치하면 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nicknameTextField.resignFirstResponder()
    }
}
