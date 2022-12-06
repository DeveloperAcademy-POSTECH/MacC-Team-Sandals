//
//  ExceptionBookmarkCell.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/23.
//

import UIKit

// 북마크 섹션이 비거나 로그인하지 않았을때 보여줄 셀
final class ExceptionBookmarkCell: UICollectionViewCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .body2
        
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("서점 큐레이션 보러가기", for: .normal)
        button.setTitleColor(UIColor(red: 0.173, green: 0.459, blue: 0.355, alpha: 1), for: .normal)
        button.titleLabel?.font = .headline
        button.setUnderline()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        button.isHidden = true
        
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc func buttonTapped() {
        print(#function)
    }
}
