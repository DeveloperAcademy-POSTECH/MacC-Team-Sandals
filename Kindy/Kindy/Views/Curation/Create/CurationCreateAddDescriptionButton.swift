//
//  CurationCreateDescriptionView.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/20.
//

import UIKit

final class CurationCreateAddDescriptionButton: UIView {
    
    var delegate: CurationCreateDelegate?

    private let addImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private let backGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.kindyLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let addImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "plus")
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let addLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 추가"
        label.font = UIFont.footnote
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.spacing = 8
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackGround()
        setupStackView()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupBackGround() {
        addSubview(backGroundView)
        NSLayoutConstraint.activate([
            backGroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backGroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backGroundView.topAnchor.constraint(equalTo: topAnchor),
            backGroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    
    private func setupButton() {
        addImageButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        addSubview(addImageButton)
        NSLayoutConstraint.activate([
            addImageButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addImageButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addImageButton.topAnchor.constraint(equalTo: topAnchor),
            addImageButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(addImageView)
        stackView.addArrangedSubview(addLabel)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            addImageView.heightAnchor.constraint(equalToConstant: 16),
            addImageView.widthAnchor.constraint(equalToConstant: 16),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc private func addButtonAction() {
        delegate?.addDescriptionButtonAction()
    }
}
