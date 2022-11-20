//
//  CurationListHeaderView.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/11/08.
//

import UIKit

final class CurationListHeaderView: UITableViewHeaderFooterView {

    // MARK: - 프로퍼티
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    let btn1 = CurationCategoryButton(categoryName: "최신")
    let btn2 = CurationCategoryButton(categoryName: "서점")
    let btn3 = CurationCategoryButton(categoryName: " 책")
    
    // MARK: - 라이프 사이클
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        createLayout()
        addCategoryButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - 메소드

    private func createLayout() {
        contentView.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func addCategoryButton() {
        [btn1, btn2, btn3].forEach{ headerLabel.addSubview($0) }
        [btn1, btn2, btn3].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
//        headerLabel.addSubview(btn1)
//        btn1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            btn2.leadingAnchor.constraint(equalTo: btn1.trailingAnchor, constant: 7),
//            btn3.leadingAnchor.constraint(equalTo: btn2.trailingAnchor, constant: 7)
            btn1.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            btn2.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            btn2.leadingAnchor.constraint(equalTo: btn1.categoryButton.trailingAnchor, constant: 16),
            btn3.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            btn3.leadingAnchor.constraint(equalTo: btn2.categoryButton.trailingAnchor, constant: 16)
//            btn1.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor, constant: 30)
            
        ])
        NSLayoutConstraint.activate([
            
        ])
    }
    
//    private func addAction() {
//        btn1.addTarget(self, action: #selector(touch), for: .touchUpInside)
//    }
//    
//    @objc func touch(_ sender: UIButton) {
//        print("touch")
//    }
}
