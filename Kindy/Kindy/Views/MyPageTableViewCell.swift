//
//  MyPageTableViewCell.swift
//  Kindy
//
//  Created by baek seohyeon on 2022/10/24.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    
    lazy var myPageCellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var myPageCellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var myPageCellStackView: UIStackView = {
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
    
    
    func setupUI() {
        self.addSubview(myPageCellStackView)
        
        myPageCellStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        myPageCellStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        myPageCellStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        
    

    }
    
}
