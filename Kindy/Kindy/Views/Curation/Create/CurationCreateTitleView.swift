//
//  CurationCreateTitleView.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/20.
//

import UIKit

final class CurationCreateTitleView: UIView {

    var mainText: String = ""
    let mainMaxCount: Int = 14
    var isMainEditable: Bool = true

    var subText: String = ""
    let subMaxCount: Int = 17
    var isSubEditable: Bool = true

    weak var delegate: CurationCreateDelegate?

    private let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .black.withAlphaComponent(0.4)
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let opacityView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let addImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let photoImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo")
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "*커버 이미지"
        label.font = UIFont.footnote
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let mainTitleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.title2
        textField.textColor = .white
        textField.tintColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: " *큐레이션 제목을 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let mainUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let mainCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.footnote
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subTitleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.title3
        textField.textColor = .white
        textField.tintColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: " *소제목을 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let subUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let subCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.footnote
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        setupBackgrouhndImage()
        setupOpacityView()
        setupSubtitleView()
        setupMaintitleView()
        setupAddImageButton()
    }

    private func setupBackgrouhndImage() {
        addSubview(backgroundImage)
        backgroundImage.image = UIImage()
        backgroundImage.sizeThatFits(self.frame.size)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    private func setupOpacityView() {
        addSubview(opacityView)
        NSLayoutConstraint.activate([
            opacityView.topAnchor.constraint(equalTo: topAnchor),
            opacityView.trailingAnchor.constraint(equalTo: trailingAnchor),
            opacityView.bottomAnchor.constraint(equalTo: bottomAnchor),
            opacityView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    private func setupSubtitleView() {
        subTitleTextField.tag = 1
        subTitleTextField.delegate = self
        subCountLabel.text = "0 / \(subMaxCount)"
        addSubview(subUnderLineView)
        addSubview(subTitleTextField)
        addSubview(subCountLabel)
        NSLayoutConstraint.activate([
            subUnderLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -28),
            subUnderLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subUnderLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            subUnderLineView.heightAnchor.constraint(equalToConstant: 0.8),

            subTitleTextField.bottomAnchor.constraint(equalTo: subUnderLineView.topAnchor, constant: -7),
            subTitleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subTitleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            subCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            subCountLabel.topAnchor.constraint(equalTo: subUnderLineView.bottomAnchor, constant: 4)

        ])
    }

    private func setupMaintitleView() {
        mainTitleTextField.tag = 0
        mainTitleTextField.delegate = self
        mainCountLabel.text = "0 / \(mainMaxCount)"
        addSubview(mainUnderLineView)
        addSubview(mainTitleTextField)
        addSubview(mainCountLabel)
        NSLayoutConstraint.activate([
            mainUnderLineView.bottomAnchor.constraint(equalTo: subTitleTextField.topAnchor, constant: -20),
            mainUnderLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainUnderLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainUnderLineView.heightAnchor.constraint(equalToConstant: 0.8),

            mainTitleTextField.bottomAnchor.constraint(equalTo: mainUnderLineView.topAnchor, constant: -7),
            mainTitleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainTitleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            mainCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainCountLabel.topAnchor.constraint(equalTo: mainUnderLineView.bottomAnchor, constant: 4)
        ])
    }

    private func setupAddImageButton() {
        addImageButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        addSubview(addImageButton)
        addSubview(photoImage)
        addSubview(buttonLabel)
        NSLayoutConstraint.activate([
            addImageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addImageButton.widthAnchor.constraint(equalToConstant: 109),
            addImageButton.heightAnchor.constraint(equalToConstant: 36),
            addImageButton.bottomAnchor.constraint(equalTo: mainTitleTextField.topAnchor, constant: -32),

            photoImage.leadingAnchor.constraint(equalTo: addImageButton.leadingAnchor, constant: 8),
            photoImage.centerYAnchor.constraint(equalTo: addImageButton.centerYAnchor),
            photoImage.widthAnchor.constraint(equalToConstant: 20),
            photoImage.heightAnchor.constraint(equalToConstant: 15),

            buttonLabel.leadingAnchor.constraint(equalTo: photoImage.trailingAnchor, constant: 8),
            buttonLabel.trailingAnchor.constraint(equalTo: addImageButton.trailingAnchor, constant: -8),
            buttonLabel.centerYAnchor.constraint(equalTo: photoImage.centerYAnchor)
        ])
    }

    func setupImage(_ image: UIImage) {
        backgroundImage.image = image
    }

    func setupTittleTest(main: String, sub: String) {
        mainText = main
        subText = sub
        mainTitleTextField.text = main
        subTitleTextField.text = sub
    }

    @objc func addButtonAction() {
        delegate?.openImagePickerForMainImage()
    }
}

extension CurationCreateTitleView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
            case 0:
                if !isMainEditable {
                    if let char = string.cString(using: String.Encoding.utf8) {
                        let isBackSpace = strcmp(char, "\\b")
                        if isBackSpace == -92 {
                            isMainEditable = true
                            delegate?.setupMainTitle(string: textField.text!)
                            return true
                        } else {
                            return false
                        }
                    }
                } else {
                    delegate?.setupMainTitle(string: textField.text!)
                    return true
                }

            case 1:
                if !isSubEditable {
                    if let char = string.cString(using: String.Encoding.utf8) {
                        let isBackSpace = strcmp(char, "\\b")
                        if isBackSpace == -92 {
                            isSubEditable = true
                            delegate?.setupSubTitle(string: textField.text!)
                            return true
                        } else {
                            return false
                        }
                    }
                } else {
                    delegate?.setupSubTitle(string: textField.text!)
                    return true
                }
            default:
                delegate?.setupSubTitle(string: textField.text!)
                return true
            }
        return true

        }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            if textField.text!.count > mainMaxCount  || !isMainEditable {
                isMainEditable = false
                self.mainTitleTextField.text = mainText
            } else {
                isMainEditable = true
                mainText = textField.text!
            }
            delegate?.setupMainTitle(string: textField.text!)
            mainCountLabel.text = "\(textField.text!.count) / \(mainMaxCount)"
        case 1:
            if textField.text!.count > subMaxCount  || !isSubEditable {
                isSubEditable = false
                self.subTitleTextField.text = subText
            } else {
                isSubEditable = true
                subText = textField.text!
            }
            delegate?.setupSubTitle(string: textField.text!)
            subCountLabel.text = "\(textField.text!.count) / \(subMaxCount)"
        default:
            return
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.textFieldEndEditing()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldEndEditing()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldEndEditing()
        return true
    }
}
