//
//  PolicySheetViewController.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/09.
//

import UIKit

class PolicySheetViewController: UIViewController {
    
    private var labelTitle:String = ""
    
    let privacy = Privacy()
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let contentText: UITextView = {
        let label = UITextView()
        label.font = UIFont.footnote
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = labelTitle
        view.backgroundColor = .white
        setupLabel()
        setupXButton()
        setupContentLabel()
        // Do any additional setup after loading the view.
    }
    
    func setupXButton() {
        xButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        view.addSubview(xButton)
        NSLayoutConstraint.activate([
            xButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            xButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            xButton.widthAnchor.constraint(equalToConstant: 20),
            xButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func setupLabel () {
        view.addSubview(titleLabel)
        let newSize = titleLabel.sizeThatFits( CGSize(width: titleLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: newSize.width),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    
    func setupContentLabel() {
        if labelTitle == "회원가입 및 운영 약관 동의" {
            contentText.text = privacy.memberPolicy
        } else {
            contentText.text = privacy.privacyPolicy
        }
        contentText.isEditable = false
        contentText.showsVerticalScrollIndicator = false
        view.addSubview(contentText)
        let newSize = contentText.sizeThatFits(CGSize(width: titleLabel.frame.width, height: CGFloat.greatestFiniteMagnitude))
        NSLayoutConstraint.activate([
            contentText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            contentText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentText.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupLabelTitle(_ title: String) {
        self.labelTitle = title
        titleLabel.text = title
    }
    
    @objc func closeAction() {
        self.dismiss(animated: true)
    }
}
