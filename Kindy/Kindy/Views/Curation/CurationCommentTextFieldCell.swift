//
//  CurationCommentTextFieldCell.swift
//  Kindy
//
//  Created by rbwo on 2022/11/21.
//

import UIKit

protocol PostComment: AnyObject {
    func postComment(content: String)
}

protocol KeyboardActionable: AnyObject {
    func keyboardWillShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
}

final class CurationCommentTextFieldCell: UICollectionViewCell {

    private var isSetLayout = false
    
    private var commentTask: Task<Void, Never>?

    private var isLoggedIn: Bool {
        return UserManager().isLoggedIn()
    }

    private var enableButton: Bool {
        didSet {
            if enableButton {
                submitBtn.setTitleColor(.kindySecondaryGreen, for: .normal)
            } else {
                submitBtn.setTitleColor(.kindyLightGray2, for: .normal)
            }
        }
    }

    weak var delegate: PostComment?

    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .kindyLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var bottomTextFieldView: UITextField = {
        let view = UITextField()
        view.backgroundColor = UIColor(red: 118 / 255, green: 118 / 255, blue: 128 / 255, alpha: 0.12)
        view.borderStyle = .roundedRect
        view.layer.cornerRadius = 8
        view.font = .footnote
        view.placeholder = "댓글을 입력해주세요."
        view.adjustsFontSizeToFitWidth = true
        view.clearButtonMode = .whileEditing
        view.addTarget(self, action: #selector(changeBtnColor), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var submitBtn: UIButton = {
        let view = UIButton()
        view.setTitle("등록", for: .normal)
        view.setTitleColor(.kindyLightGray2, for: .normal)
        view.titleLabel?.font = .subhead
        view.addTarget(self, action: #selector(submitComment), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()

        var frame = layoutAttributes.frame
        frame.size.width = UIScreen.main.bounds.width
        frame.size.height = 62

        layoutAttributes.frame = frame
        return layoutAttributes
    }

    override init(frame: CGRect) {
        enableButton = false
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.addSubview(lineView)
        self.addSubview(bottomTextFieldView)
        self.addSubview(submitBtn)

        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            lineView.topAnchor.constraint(equalTo: topAnchor),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),

            bottomTextFieldView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            bottomTextFieldView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomTextFieldView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -58),
            bottomTextFieldView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            submitBtn.centerYAnchor.constraint(equalTo: bottomTextFieldView.centerYAnchor),
            submitBtn.leadingAnchor.constraint(equalTo: bottomTextFieldView.trailingAnchor, constant: 16),
            submitBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    @objc private func submitComment() {
        commentTask = Task {
            if self.enableButton {
                if isLoggedIn {
                    delegate?.postComment(content: bottomTextFieldView.text!)
                    bottomTextFieldView.text = nil
                    self.enableButton = false
                }
                else {
                    NotificationCenter.default.post(name: .Loggin, object: nil)
                }
            }
        }
    }

    @objc private func changeBtnColor(sender: UITextField) {
        if sender.text?.isEmpty == true {
            self.enableButton = false
       } else {
           self.enableButton = true
       }
    }
}
