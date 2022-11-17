//
//  CurationCategoryButton.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/11/12.
//

import UIKit

final class CurationCategoryButton: UIButton {

    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        
        button.setTitle("  \(categoryName)", for: .normal)
        button.setImage(categorySymbolImage, for: .normal)
        button.tintColor = .kindyPrimaryGreen
        
        button.setTitleColor(.black, for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .leading
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.kindySecondaryGreen?.cgColor
//        button.frame = CGRect(x: 0, y: 0, width: 74, height: 32)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 13, bottom: 8, right: 13)
//        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        return button
    }()
    
    var categoryName: String = "" {
        didSet {
//            categoryButton.setTitle("  \(categoryName)", for: .normal)
//            categoryButton.setImage(categorySymbolImage, for: .normal)
        }
    }
    
    var categorySymbolImage: UIImage {
        switch categoryName {
        case "최신":
            return UIImage(systemName: "sparkles")!
        case "서점":
            return UIImage(systemName: "heart")!
        case "책":
            return UIImage(systemName: "book")!
        default:
            return UIImage(systemName: "circle")!
        }
    }
    
    init(categoryName: String) {
        super.init(frame: .zero)
        self.categoryName = categoryName
        setup()
    }
    
    private func setup() {
//        self.translatesAutoresizingMaskIntoConstraints = false
//        self.layer.cornerRadius = 12
//        self.clipsToBounds = true
        
        self.addSubview(categoryButton)
//        NSLayoutConstraint.activate([
//            categoryButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
//            categoryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
//            categoryButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            self.heightAnchor.constraint(equalToConstant: 24)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
