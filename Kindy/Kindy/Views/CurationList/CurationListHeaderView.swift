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

    // MARK: - 라이프 사이클
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - 메소드
    
    private func setup() {
        contentView.addSubview(headerLabel)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
