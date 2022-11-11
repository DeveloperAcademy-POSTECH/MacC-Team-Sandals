//
//  CurationReplyCell.swift
//  Kindy
//
//  Created by rbwo on 2022/11/08.
//

import UIKit

final class CurationReplyCell: UICollectionViewCell {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userLabel: UILabel = {
        let view = UILabel()
        view.font = .subhead
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .footnote
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .subhead
        view.textColor = .kindyLightGray
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    private lazy var reportBtn: UIButton = {
        let view = UIButton(frame: CGRect(x: 0, y: 0, width: 23, height: 18))
        view.setTitle("신고", for: .normal)
        view.setTitleColor(.kindyLightGray, for: .normal)
        view.setBackgroundImage(UIImage(), for: .normal)
        view.titleLabel?.font = UIFont.subhead
        view.addTarget(self, action: #selector(presentReportView), for: .touchUpInside)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        
        var frame = layoutAttributes.frame
        frame.size.width = UIScreen.main.bounds.width
        frame.size.height = stackView.bounds.height > 88 ? stackView.bounds.height : 88

        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    private func setupView() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(userLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(bottomStackView)
        bottomStackView.addArrangedSubview(dateLabel)
        bottomStackView.addArrangedSubview(reportBtn)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    func configure(data: [String]) {
        userLabel.text = data[0]
        descriptionLabel.text = data[1]
        dateLabel.text = data[2]        
    }
    
    @objc func presentReportView() {
        NotificationCenter.default.post(name: .Report, object: nil)
    }
}
