//
//  CurationCreateDescriptionTableViewCell.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/20.
//

import UIKit

class CurationCreateDescriptionTableViewCell: UITableViewCell {
    
    private var textViewDelegate: UITextViewDelegate?
    private var delegate: CurationCreateDelegate?
    private var index: Int = 0
    
    private let photoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "AppIcon")
        view.sizeToFit()
        view.backgroundColor = UIColor.kindyGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let textView: UITextView = {
        let view = UITextView()
        view.text = "사진 설명을 입력해 주세요"
        view.isEditable = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.clear.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let deleteButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    
    private let deleteImage: UIImageView = {
        let image = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        image.image = UIImage(systemName: "xmark.circle.fill")?.withConfiguration(configuration)
        image.tintColor = .red
        image.backgroundColor = .white
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 0
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    } ()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        setupPhotoView()
        setupTextView()
        setupButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupPhotoView() {
        addSubview(photoView)
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: topAnchor),
            photoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoView.widthAnchor.constraint(equalToConstant: 100),
            photoView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func setupTextView() {
        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 100),
            textView.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 16)
        ])
    }
    
    private func setupButton() {
        deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        addSubview(deleteButton)
        addSubview(deleteImage)
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: 4),
            deleteButton.topAnchor.constraint(equalTo: photoView.topAnchor, constant: 4),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),
            
            deleteImage.leadingAnchor.constraint(equalTo: photoView.leadingAnchor, constant: 4),
            deleteImage.topAnchor.constraint(equalTo: photoView.topAnchor, constant: 4),
            deleteImage.widthAnchor.constraint(equalToConstant: 20),
            deleteImage.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setupData(_ string: String, _ image: UIImage?, index: Int, textViewDelegate: UITextViewDelegate, delegate: CurationCreateDelegate) {
        self.index = index
        self.delegate = delegate
        textView.tag = index
        if string.isEmpty {
            textView.text = "사진 설명을 입력해 주세요"
            textView.textColor = UIColor.kindyGray
        } else {
            textView.text = string
        }
        textView.delegate = textViewDelegate
        if let image = image {
            photoView.image = image
        }
    }
    
    @objc func deleteItem() {
        delegate?.deleteItem(index: index)
    }
    
    
}
