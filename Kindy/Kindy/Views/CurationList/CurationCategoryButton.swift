//
//  CurationCategoryButton.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/11/12.
//

import UIKit

final class CurationCategoryButton: UIButton {

    lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .body2
        button.tintColor = .kindyPrimaryGreen
        button.contentVerticalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var categoryName: String = ""
    
    var categorySymbolImage: UIImage {
        switch categoryName {
        case "최신":
            return UIImage(systemName: "sparkles")!
        case "서점":
            return UIImage(systemName: "heart")!
        case " 책":
            return UIImage(systemName: "book")!
        default:
            return UIImage(systemName: "circle")!
        }
    }
    
    init(categoryName: String) {
        super.init(frame: .zero)
        self.categoryName = categoryName
        createLayout()
        configureButton()
    }
    
    private func createLayout() {
        self.addSubview(categoryButton)
        
        NSLayoutConstraint.activate([
            categoryButton.widthAnchor.constraint(equalToConstant: 74),
            categoryButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func configureButton() {
        categoryButton.setTitle("  \(categoryName)", for: .normal)
        categoryButton.setImage(categorySymbolImage, for: .normal)
        
        categoryButton.backgroundColor = .clear
        categoryButton.layer.cornerRadius = 8
        categoryButton.layer.borderWidth = 1.5
        categoryButton.layer.borderColor = UIColor.kindySecondaryGreen?.cgColor
        
        if categoryName == "최신" {
            categoryButton.backgroundColor = .kindySecondaryGreen
            categoryButton.tintColor = .white
            categoryButton.setTitleColor(.white, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
