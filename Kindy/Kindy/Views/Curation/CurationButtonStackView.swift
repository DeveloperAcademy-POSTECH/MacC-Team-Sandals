//
//  CurationButtonStackView.swift
//  Kindy
//
//  Created by rbwo on 2022/11/09.
//

import UIKit

// MARK: reply 기능은 추가가 되면 주석 해제
final class CurationButtonStackView: UIView {

    private let curation: Curation
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var heartView: UIView = {
        let view = CurationButtonItemView(frame: .zero, curation: curation, viewName: .heart)
        return view
    }()

    private lazy var replyView: UIView = {
        let view = CurationButtonItemView(frame: .zero, curation: curation, viewName: .reply)
        return view
    }()
    
    init(frame: CGRect, curation: Curation) {
        self.curation = curation
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(heartView)
//        stackView.addArrangedSubview(replyView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
}
