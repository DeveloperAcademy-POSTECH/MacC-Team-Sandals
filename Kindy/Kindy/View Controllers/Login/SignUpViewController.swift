//
//  SecondLoginViewController.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/08.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

final class SignUpViewController: UIViewController {

    let db = Firestore.firestore()
    
    var credential: AuthCredential?
    var provider: String?
    var email: String?
    var nickName: String = ""
    var nickNameArray: [String]?
    private var isChecked: Bool = false {
        didSet {
            self.isEnable()
        }
    }
    
    private let signUpView = SignUpView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "회원가입"
        view.backgroundColor = .white
        setupView()
    }
    
    private func setupView() {
        signUpView.translatesAutoresizingMaskIntoConstraints = false
        signUpView.delegate = self
        view.addSubview(signUpView)
        NSLayoutConstraint.activate([
            signUpView.topAnchor.constraint(equalTo: view.topAnchor),
            signUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            signUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func signUp() {
        
        db.collection("Users").getDocuments(completion: { (documents, error) in
            self.nickNameArray = documents?.documents.map{ $0.data() }.map{ String(describing: $0["nickName"]!) }
            Task {
                if try await UserManager().isExistingNickname(self.nickName) {
                    self.signUpView.isAlreadyLabel.alpha = 1
                    self.signUpView.underLineView.layer.borderColor = UIColor.red.cgColor
                } else {
                    self.signUpView.signUpButton.isEnabled = false
                    self.signUpView.isAlreadyLabel.alpha = 0
                    self.signUpView.underLineView.layer.borderColor = UIColor.black.cgColor
                    Auth.auth().signIn(with: self.credential!) { [weak self] result, error in
                        guard let self = self else { return }
                        guard result != nil, error == nil else {
                            if let error = error {
                                print("Error google Login - \(error) ")
                            }
                            return
                        }
                        // Auth.auth().currentUser.uid 값을 가지고 FireStore에 유저 컬렉션에 해당 도큐먼트가 있는지 확인
                        // 확인 후 없다면 해당 유저 도큐먼트를
                        self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
                            "email" : self.email!,
                            "provider" : self.provider!,
                            "nickName" : self.nickName,
                            "bookmarkedBookstores" : []
                        ])  { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                            let viewControllers = self.navigationController?.viewControllers
                            if viewControllers?.count == 2 {
                                self.dismiss(animated: true)
                            } else {
                                self.navigationController?.popToViewController(viewControllers![viewControllers!.count - 3], animated: true)
                            }
                        }
                        
                    }
                }
            }
        })
    }
    
    // MARK: 닉네임 입력 및 정책 체크 상태 파악하여 버튼 상태 변경
    func isEnable() {
        if !nickName.isEmpty && isChecked {
            signUpView.signUpButton.isEnabled = true
        } else {
            signUpView.signUpButton.isEnabled = false
        }
    }
}


extension SignUpViewController: SignUpDelegate {
    func isToggle(_ totalCheck: Bool) {
        isChecked = totalCheck
    }
    
    func policySheetOpen(_ title: String) {
        let vc = PolicySheetViewController()
        vc.setupLabelTitle(title)
        present(vc, animated: true)
    }
    
    func signUpDelegate() {
        self.signUp()
    }
    
    func textFieldAction(_ nickname: String) {
        self.nickName = nickname
        self.isEnable()
    }
    
}
