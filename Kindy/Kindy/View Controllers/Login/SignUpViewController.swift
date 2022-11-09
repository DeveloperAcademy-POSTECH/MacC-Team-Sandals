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

class SignUpViewController: UIViewController {
    
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
    
    private let underLineView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let checkPolicyView: CheckPolicyUIView = {
        let view = CheckPolicyUIView()
//        view.backgroundColor = UIColor.kindyLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    
    private let isAlreadyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.footnote
        label.textColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let signInButton: UIButton = {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        nickNameTextField.delegate = self
        self.navigationItem.title = "회원가입"
        view.backgroundColor = .white
        setupDescriptionLabel()
        setupNickNameTextField()
        setupUnderLineView()
        setupIsAlreadyLabel()
        setupTempView()
        setupSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = "(필수) 사용하실 닉네임을 입력해주세요"
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 123),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
    
    private func setupNickNameTextField() {
        nickNameTextField.delegate = self
        nickNameTextField.placeholder = "닉네임을 입력해주세요"
        view.addSubview(nickNameTextField)
        NSLayoutConstraint.activate([
            nickNameTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 23),
            nickNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nickNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupUnderLineView() {
        view.addSubview(underLineView)
        NSLayoutConstraint.activate([
            underLineView.topAnchor.constraint(equalTo: nickNameTextField.bottomAnchor, constant: 15),
            underLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            underLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            underLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupIsAlreadyLabel() {
        isAlreadyLabel.text = "이미 사용 중인 닉네임입니다."
        isAlreadyLabel.alpha = 0
        view.addSubview(isAlreadyLabel)
        NSLayoutConstraint.activate([
            isAlreadyLabel.topAnchor.constraint(equalTo: underLineView.bottomAnchor, constant: 8),
            isAlreadyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupTempView() {
        checkPolicyView.delegate = self
        view.addSubview(checkPolicyView)
        NSLayoutConstraint.activate([
            checkPolicyView.topAnchor.constraint(equalTo: underLineView.bottomAnchor, constant: 56),
            checkPolicyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkPolicyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            checkPolicyView.heightAnchor.constraint(equalToConstant: 124)
        ])
    }
    
    private func setupSignIn() {
        signInButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        signInButton.setTitle("회원가입", for: .normal)
        signInButton.isEnabled = false
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: checkPolicyView.bottomAnchor, constant: 16),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signInButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc func signUp() {
        
        db.collection("users").getDocuments(completion: { (documents, error) in
            self.nickNameArray = documents?.documents.map{ $0.data() }.map{ String(describing: $0["nickName"]!) }
        })
        
        if let array = nickNameArray, !array.contains(nickName) {
            db.collection("users").document(email!).setData([
                "email" : email!,
                "provider" : provider!,
                "nickName" : nickName
            ])  { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    
                    Auth.auth().signIn(with: self.credential!) { [weak self] result, error in
                        guard let self = self else { return }
                        guard
                            result != nil,
                            error == nil else {
                            if let error = error {
                                print("Error google Login - \(error) ")
                            }
                            return
                        }
                        print("Successfull Log in \(result.publisher)")
                        // Auth.auth().currentUser.uid 값을 가지고 FireStore에 유저 컬렉션에 해당 도큐먼트가 있는지 확인
                        // 확인 후 없다면 해당 유저 도큐먼트를
                        
                        let viewControllers = self.navigationController?.viewControllers
                        self.navigationController?.popToViewController(viewControllers![viewControllers!.count - 3], animated: true)
                    }
                }
            }
            
        } else {
            isAlreadyLabel.alpha = 1
            underLineView.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    func isEnable() {
        if !nickName.isEmpty && isChecked {
            self.signInButton.isEnabled = true
        } else {
            self.signInButton.isEnabled = false
        }
    }
}


extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        self.nickName = newText
        self.isEnable()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}


extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}


extension SignUpViewController: SignUpDelegate {
    func isToggle(_ totalCheck: Bool) {
        isChecked = totalCheck
    }
    
    func policySheetOpen(_ title: String) {
        let vc = PolicySheetViewController()
        vc.setupLabelTitle(title)
//        if let sheet = vc.sheetPresentationController {
//            sheet.delegate = [.large()]
//        }
        present(vc, animated: true)
    }
    
}
