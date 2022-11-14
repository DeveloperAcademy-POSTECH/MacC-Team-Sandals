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

    var headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 7
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    let btn1 = CurationCategoryButton(categoryName: "최신")
    let btn2 = CurationCategoryButton(categoryName: "서점")
    let btn3 = CurationCategoryButton(categoryName: "책")
    
    // MARK: - 라이프 사이클
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
        createLayout()
        addCategoryButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - 메소드
    
    private func setup() {
        headerLabel.addSubview(headerStackView)
        contentView.addSubview(headerLabel)
    }

    private func createLayout() {
        NSLayoutConstraint.activate([
            headerStackView.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            headerStackView.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func addCategoryButton() {
        
        [btn1, btn2, btn3].forEach{ headerLabel.addSubview($0) }
        
        NSLayoutConstraint.activate([
            btn2.leadingAnchor.constraint(equalTo: btn1.trailingAnchor, constant: 7),
            btn3.leadingAnchor.constraint(equalTo: btn2.trailingAnchor, constant: 7)
        ])
        NSLayoutConstraint.activate([
            
        ])
    }
}
