//
//  MyPageTableViewCell.swift
//  Kindy
//
//  Created by baek seohyeon on 2022/10/24.
//

import UIKit

final class MyPageTableViewCell: UITableViewCell {
    
    // MARK: Properties
    var myPageCellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let myPageCellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = UIColor(named: "kindyGray2")
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
    
    // MARK: LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Helpers
    private func setupUI() {
        addSubview(myPageCellStackView)
        
        NSLayoutConstraint.activate([
            myPageCellImageView.widthAnchor.constraint(equalToConstant: 14),
            
            myPageCellStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            myPageCellStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding16),
            myPageCellStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding16)
        ])
    }
    
}
