//
//  SectionHeaderView.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/20.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "SectionHeaderView"
    
    // MARK: Delegate Definition
    weak var delegate: SectionHeaderDelegate?
    
    var sectionIndex: Int = 0
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.tintColor = .black
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
        label.text = "포항시, 북구"
        return label
    }()
    
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location.fill")
        imageView.tintColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
        return imageView
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.addArrangedSubview(topStackView)
        stackView.addArrangedSubview(bottomStackView)
        topStackView.addArrangedSubview(nameLabel)
        topStackView.addArrangedSubview(seeAllButton)
        bottomStackView.addArrangedSubview(regionLabel)
        bottomStackView.addArrangedSubview(locationImageView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            locationImageView.widthAnchor.constraint(equalToConstant: 13),
            locationImageView.heightAnchor.constraint(equalToConstant: 13)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String, color: UIColor, hideSeeAllButton: Bool, hideBottomStackView: Bool, sectionIndex: Int) {
        nameLabel.text = title
        nameLabel.textColor = color
        seeAllButton.isHidden = hideSeeAllButton
        bottomStackView.isHidden = hideBottomStackView
        
        self.sectionIndex = sectionIndex
    }
    
    @objc func seeAllButtonTapped() {
        delegate?.segueWithSectionIndex(sectionIndex)
    }
}
