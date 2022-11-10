//
//  MyPageTableViewCell.swift
//  Kindy
//
//  Created by baek seohyeon on 2022/10/24.
//

import UIKit

final class MyPageTableViewCell: UITableViewCell {
    
    var myPageCellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let myPageCellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = .black
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var myPageCellStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [myPageCellLabel, myPageCellImageView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(myPageCellStackView)
        
        NSLayoutConstraint.activate([
            myPageCellStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            myPageCellStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            myPageCellStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
}
