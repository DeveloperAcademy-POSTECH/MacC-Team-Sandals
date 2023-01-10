//
//  CheckboxUIView.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/09.
//

import UIKit

class CheckboxUIView: UIView {

    weak var delegate: CheckPolicyDelegate?
    var position: String = ""

    var isChecked: Bool = false {
        didSet {
            if isChecked {
                checkButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
                checkButton.tintColor = UIColor.kindyPrimaryGreen
            } else {
                checkButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
                checkButton.tintColor = UIColor.kindyGray
            }
        }
    }

    private let checkButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = UIColor.kindyGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sheetButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        setupCheckButton()
        setupTitleLabel()
        if position == "first" || position == "second" {
            setupSheetButton()
        }
    }

    private func setupCheckButton() {
        checkButton.addTarget(self, action: #selector(checkAction), for: .touchUpInside)
        addSubview(checkButton)
        NSLayoutConstraint.activate([
            checkButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkButton.topAnchor.constraint(equalTo: topAnchor),
            checkButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupSheetButton() {
        sheetButton.addTarget(self, action: #selector(sheetOpen), for: .touchUpInside)
        addSubview(sheetButton)
        NSLayoutConstraint.activate([
            sheetButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            sheetButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sheetButton.widthAnchor.constraint(equalToConstant: 8),
            sheetButton.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    func setupTitle(type: String, title: String) {
        titleLabel.text = title
        if type == "main" {
            titleLabel.font = UIFont.subhead
        } else {
            titleLabel.font = UIFont.footnote
        }
    }

    @objc func checkAction() {
        if position == "first" {
            delegate?.isFirstToggle()
        } else if position == "second" {
            delegate?.isSecondToggle()
        } else if position == "total" {
            delegate?.isTotalToogle()
        }
    }

    @objc func sheetOpen() {
        var title = ""
        if position == "first" {
            title = "회원가입 및 운영 약관 동의"
        } else if position == "second" {
            title = "개인정보 수집 및 이용 동의"
        }
        delegate?.policySheetOpen(title)
    }

}
