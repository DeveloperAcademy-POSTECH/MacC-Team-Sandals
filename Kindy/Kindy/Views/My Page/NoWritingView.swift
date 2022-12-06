//
//  NoWritingView.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/27.
//

import UIKit

final class NoWritingView: UIView {
    
    // MARK: Properties
    let noWritingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let noWritingButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "kindyPrimaryGreen"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var noWritingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [noWritingLabel, noWritingButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    private func setupUI() {
        addSubview(noWritingStackView)
        
        NSLayoutConstraint.activate([
            noWritingStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noWritingStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
