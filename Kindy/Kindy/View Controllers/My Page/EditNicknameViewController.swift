//
//  EditNicknameViewController.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/16.
//

import UIKit

final class EditNicknameViewController: UIViewController {

    // MARK: Properties
    private let userManager = UserManager()
    private var userNicknameRequestTask: Task<Void, Never>?

    private let maxNicknameLength = 10

    private let editNicknameView = EditNicknameView()

    private lazy var navigationEditButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(editButtonTapped))
        button.tintColor = UIColor(named: "kindyGray2")
        button.isEnabled = false
        return button
    }()

    // MARK: LifeCycle
    override func loadView() {
        view = editNicknameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        editNicknameView.nicknameTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        tabBarController?.tabBar.isHidden = true
    }

    deinit {
        userNicknameRequestTask?.cancel()
    }

    // MARK: Helpers
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = navigationEditButton
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "내 정보 수정"
        navigationController?.navigationBar.tintColor = UIColor.black
    }

    // MARK: Actions
    @objc func editButtonTapped() {
        // 텍스트필드의 텍스트로 닉네임 중복 검사
        guard let currentNickname = editNicknameView.nicknameTextField.text else { return }

        userNicknameRequestTask?.cancel()

        userNicknameRequestTask = Task {
            guard let isExistingNickname = try? await userManager.isExistingNickname(currentNickname) else { return }

            switch isExistingNickname {
            case true:
                changeViewComponents(with: true)

            case false:
                userManager.editNickname(currentNickname)
                _ = navigationController?.popViewController(animated: true)
            }
            userNicknameRequestTask = nil
        }
    }

}

// MARK: Extensions
// MARK: UITextFieldDelegate
extension EditNicknameViewController: UITextFieldDelegate {

    // 텍스트필드 입력될 때마다 호출
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let previousNSString: NSString = (textField.text ?? "") as NSString
        let currentNSString: NSString = previousNSString.replacingCharacters(in: range, with: string) as NSString
        let currentTextFieldText: String = currentNSString as String

        // 텍스트 필드가 비어져있으면 완료 버튼 비활성화
        if currentTextFieldText.count == 0 {
            deactivateEditButton()
        } else {
            navigationEditButton.tintColor = .black
            navigationEditButton.isEnabled = true
        }

        // 최대글자수 10자로 제한
        return currentNSString.length <= maxNicknameLength
    }

    // 텍스트필드 입력이 완료되었을때
    func textFieldDidEndEditing(_ textField: UITextField) {
        editNicknameView.nicknameTextField.resignFirstResponder()

        // 텍스트가 입력되었으면
        guard let text = textField.text, text.count != 0 else { return }

        userNicknameRequestTask?.cancel()

        // 유저 닉네임 중복 검사
        userNicknameRequestTask = Task {
            guard let isExistingNickname = try? await userManager.isExistingNickname(text) else { return }

            switch isExistingNickname {
            case true:
                changeViewComponents(with: isExistingNickname)

            case false:
                changeViewComponents(with: isExistingNickname)
            }
            userNicknameRequestTask = nil
        }
    }

    // 텍스트필드의 클리어버튼이 눌렸을때 호출
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        deactivateEditButton()
        return true
    }

    // 키보드의 완료 버튼 누르면 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        editNicknameView.nicknameTextField.resignFirstResponder()
        return true
    }

    // 키보드 외 영역 터치하면 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        editNicknameView.nicknameTextField.resignFirstResponder()
    }

    // 닉네임 상태에 따라 UI 변경
    private func changeViewComponents(with isExistingNickname: Bool) {
        switch isExistingNickname {
        case true:
            editNicknameView.textFieldUnderLine.backgroundColor = .red
            editNicknameView.warningLabel.text = "이미 사용 중인 닉네임입니다."
            editNicknameView.warningLabel.textColor = .red

        case false:
            editNicknameView.textFieldUnderLine.backgroundColor = .systemGreen
            editNicknameView.warningLabel.text = "사용 가능한 닉네임입니다."
            editNicknameView.warningLabel.textColor = .systemGreen
        }
    }

    // 네비게이션 완료 버튼 비활성화
    private func deactivateEditButton() {
        editNicknameView.textFieldUnderLine.backgroundColor = UIColor(named: "kindyGray")
        editNicknameView.warningLabel.text = ""
        navigationEditButton.tintColor = UIColor(named: "kindyGray2")
        navigationEditButton.isEnabled = false
    }

}
