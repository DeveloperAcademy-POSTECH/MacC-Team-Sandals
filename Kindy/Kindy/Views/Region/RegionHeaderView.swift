//
//  RegionHeaderView.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/22.
//
import UIKit

final class RegionHeaderView: UITableViewHeaderFooterView {

    // MARK: - 프로퍼티
    

    var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
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
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
        ])
    }
}
