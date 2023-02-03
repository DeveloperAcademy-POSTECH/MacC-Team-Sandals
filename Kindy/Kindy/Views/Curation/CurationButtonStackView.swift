//
//  CurationButtonStackView.swift
//  Kindy
//
//  Created by rbwo on 2022/11/09.
//

import UIKit

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

    private(set) lazy var heartView: UIView = {
        let view = CurationButtonItemView(frame: .zero, curation: curation, viewName: .heart)
        return view
    }()

    private(set) lazy var replyView: UIView = {
        let view = CurationButtonItemView(frame: .zero, curation: curation, viewName: .comment)
        return view
    }()

    private(set) lazy var settingView: UIView = {
        let view = CurationButtonItemView(frame: .zero, viewName: .setting)
        view.translatesAutoresizingMaskIntoConstraints = false
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
        stackView.addArrangedSubview(replyView)
        self.addSubview(settingView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            settingView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            settingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
