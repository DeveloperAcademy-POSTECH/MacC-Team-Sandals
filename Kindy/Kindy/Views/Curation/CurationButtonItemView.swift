//
//  CurationFooterView.swift
//  Kindy
//
//  Created by rbwo on 2022/11/09.
//

import UIKit

final class CurationButtonItemView: UIView {
    
    enum Views {
        case heart
        case reply
    }
    
    private let buttonImage: String
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonView: UIButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: buttonImage, withConfiguration: imageConfig)
        
        view.setImage(image, for: .normal)
        view.tintColor = .kindySecondaryGreen
        
        view.addTarget(self, action: #selector(customAction), for: .touchUpInside)
        return view
    }()
    
    private let countLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .headline
        view.textColor = .black
        return view
    }()
    
    init(frame: CGRect, viewName: Views) {
        switch viewName {
        case .heart:
            self.buttonImage = "heart"
            self.countLabel.text = "12"
        case .reply:
            self.buttonImage = "bubble.left"
            self.countLabel.text = "14"
        }
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(buttonView)
        stackView.addArrangedSubview(countLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private extension CurationButtonItemView {
    // 어케 분기? 함수 2개 ? 할지 생각 ~
   @objc func customAction() {
        print("hi")
    }
}
