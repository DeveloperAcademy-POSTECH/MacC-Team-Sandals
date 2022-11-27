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
        label.font = UIFont.systemFont(ofSize: 17)
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
    
    private let cellSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "kindyLightGray2")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(cellSeperator)
        
        NSLayoutConstraint.activate([
            myPageCellImageView.widthAnchor.constraint(equalToConstant: 14),
            
            myPageCellStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            myPageCellStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding16),
            myPageCellStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding16),
            myPageCellStackView.heightAnchor.constraint(equalToConstant: 25),
            
            cellSeperator.topAnchor.constraint(equalTo: myPageCellStackView.bottomAnchor, constant: 15),
            cellSeperator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding16),
            cellSeperator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding16),
            cellSeperator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
}
