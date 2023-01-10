//
//  CurationCreateHeadTextView.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/20.
//

import UIKit

final class CurationCreateHeadTextView: UIView {

    private let textViewPlaceHolder: String = "본문 내용을 작성해 주세요"

    private weak var delegate: CurationCreateDelegate?

    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
//        stackView.offset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.layer.borderColor = UIColor.kindyGray?.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 8
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.body2
        label.text = "*게시글의 카테고리를 선택해 주세요"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chevronDownImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.kindyLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.clear.cgColor
        textView.showsVerticalScrollIndicator = false
        textView.tintColor = .black
        textView.textColor = UIColor.kindyGray
        textView.font = UIFont.body2
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openTab))
        gesture.numberOfTapsRequired = 1
        categoryStackView.isUserInteractionEnabled = true
        categoryStackView.addGestureRecognizer(gesture)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        setupCategory()
        setupDivider()
        setupHeadTextView()
    }

    private func setupCategory() {
        addSubview(categoryStackView)
        categoryStackView.addArrangedSubview(categoryLabel)
        categoryStackView.addArrangedSubview(chevronDownImage)
        NSLayoutConstraint.activate([
            categoryStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            categoryStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            categoryStackView.heightAnchor.constraint(equalToConstant: 34),
            chevronDownImage.widthAnchor.constraint(equalToConstant: 14)
        ])
    }

    private func setupDivider() {
        addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 16),
            dividerView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func setupHeadTextView() {
        headTextView.text = textViewPlaceHolder
        headTextView.tag = 99
        addSubview(headTextView)
        headTextView.isEditable = true
        headTextView.allowsEditingTextAttributes = true
        NSLayoutConstraint.activate([
            headTextView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 32),
            headTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headTextView.heightAnchor.constraint(equalToConstant: 230)
        ])
    }

    func setupDelegate(_ textViewDelegate: UITextViewDelegate, _ curationCreateDelegate: CurationCreateDelegate) {
        headTextView.delegate = textViewDelegate
        self.delegate = curationCreateDelegate
    }

    func setupCategory(_ string: String) {
        categoryLabel.text = string
    }

    func setupText(string: String) {
        if !string.isEmpty {
            headTextView.text = string
            headTextView.textColor = .black
        }

    }

    @objc private func openTab() {
        delegate?.selectCategory()
    }

}
