//
//  CurationListHeaderView.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/11/08.
//

import UIKit

final class CurationListHeaderView: UITableViewHeaderFooterView {

    // MARK: - 프로퍼티
    
    private let headerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let latestButton = CurationCategoryButton(categoryName: "최신").categoryButton
    let bookstoreButton = CurationCategoryButton(categoryName: "서점").categoryButton
    let bookButton = CurationCategoryButton(categoryName: "책").categoryButton
    
    // MARK: - 라이프 사이클
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        createLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - 메소드

    private func createLayout() {
        contentView.addSubview(headerStackView)
        [latestButton, bookstoreButton, bookButton].forEach{ headerStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
