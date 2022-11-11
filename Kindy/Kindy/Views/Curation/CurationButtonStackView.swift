//
//  CurationButtonStackView.swift
//  Kindy
//
//  Created by rbwo on 2022/11/09.
//

import UIKit

final class CurationButtonStackView: UIView {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(CurationButtonItemView(frame: .zero, viewName: .heart))
        stackView.addArrangedSubview(CurationButtonItemView(frame: .zero, viewName: .reply))
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
}
