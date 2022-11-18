//
//  EditNicknameViewController.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/16.
//

import UIKit

// TODO: MVC 패턴에 맞게 수정
// TODO: 닉네임 수정 메소드 FirestoreManager에 추가
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
        textField.placeholder = "닉네임을 입력해주세요"
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
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
        tabBarController?.tabBar.isHidden = true
        navigationItem.rightBarButtonItem = navigationEditButton
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
        // 텍스트필드의 텍스트로 닉네임 중복 검사
        guard let text = nicknameTextField.text else { return }
        
        userNicknameRequestTask?.cancel()
        
        userNicknameRequestTask = Task {
            guard let isExistingNickname = try? await firestoreManager.isExistingNickname(text) else { return }
            switch isExistingNickname {
            case true:
                textFieldUnderLine.backgroundColor = .red
                warningLabel.text = "이미 사용 중인 닉네임입니다."
                warningLabel.textColor = .red
                
            case false:
//                firestoreManager.editNickname(nicknameTextField.text)
                userNicknameRequestTask = nil
                navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
}

// MARK: Extensions
// MARK: UITextFieldDelegate
extension EditNicknameViewController: UITextFieldDelegate {
    
    // 텍스트필드 입력될 때마다 호출
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentNSString: NSString = (textField.text ?? "") as NSString
        let newNSString: NSString = currentNSString.replacingCharacters(in: range, with: string) as NSString
        let currentTextFieldText: String = newNSString as String
        
        // 텍스트 필드가 비어져있으면 완료 버튼 비활성화
        if currentTextFieldText.count == 0 {
            textFieldUnderLine.backgroundColor = UIColor(named: "kindyGray")
            warningLabel.text = ""
            navigationEditButton.tintColor = UIColor(named: "kindyGray2")
            navigationEditButton.isEnabled = false
        } else {
            navigationEditButton.tintColor = .black
            navigationEditButton.isEnabled = true
        }
        
        // 최대글자수 10자로 제한
        return newNSString.length <= maxLength
    }
    
    // 텍스트필드 입력이 완료되었을때
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 키보드를 내리고
        nicknameTextField.resignFirstResponder()
        
        // 텍스트가 입력되었으면
        guard let text = textField.text else { return }
        guard text.count != 0 else { return }
        
        userNicknameRequestTask?.cancel()
        
        // 유저 닉네임 중복 검사
        userNicknameRequestTask = Task {
            guard let isExistingNickname = try? await firestoreManager.isExistingNickname(text) else { return }
            
            switch isExistingNickname {
            // 닉네임이 중복될때 UI 변경
            case true:
                textFieldUnderLine.backgroundColor = .red
                warningLabel.text = "이미 사용 중인 닉네임입니다."
                warningLabel.textColor = .red
                
            // 닉네임이 중복되지 않을때 UI 변경
            case false:
                textFieldUnderLine.backgroundColor = .systemGreen
                warningLabel.text = "사용 가능한 닉네임입니다."
                warningLabel.textColor = .systemGreen
            }
            userNicknameRequestTask = nil
        }
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
    
    // 텍스트필드의 클리어버튼이 눌렸을때 호출
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // UI 수정 및 버튼 비활성화
        textFieldUnderLine.backgroundColor = UIColor(named: "kindyGray")
        warningLabel.text = ""
        navigationEditButton.tintColor = UIColor(named: "kindyGray2")
        navigationEditButton.isEnabled = false
        return true
    }
}
