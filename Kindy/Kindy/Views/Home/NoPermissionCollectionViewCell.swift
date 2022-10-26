//
//  NoPermissionCollectionViewCell.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/26.
//

import UIKit

// 위치 정보 수집 권한 없을때 내 주변 서점에 보여줄 셀
final class NoPermissionCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "NoPermissionCollectionViewCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "위치정보 접근 권한을 설정해주시면\n현재 내위치 주변의 서점을 찾아드릴게요!"
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.text = "휴대폰 설정 > 킨디 > 위치정보 접근 허용"
        label.textColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
        return label
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.addArrangedSubview(topLabel)
        stackView.addArrangedSubview(bottomLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

