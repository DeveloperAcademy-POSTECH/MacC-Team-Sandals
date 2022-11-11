//
//  CurationInfoCell.swift
//  Kindy
//
//  Created by rbwo on 2022/10/25.
//

import UIKit

final class CurationTextCell: UICollectionViewCell {
    
    private var viewSize = CGRect()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.numberOfLines = 0
        view.font = .body2
        view.textAlignment = .left
        return view
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .kindyLightGray
        view.alpha = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()
        
        let maxSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let heightOnFont = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        viewSize = NSString(string: textLabel.text!).boundingRect(with: maxSize,options: heightOnFont, attributes: [.font: UIFont.body2!], context: nil)
        
        viewSize.size.height += 50
        layoutAttributes.frame = viewSize
        return layoutAttributes
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(stackView)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(dividerView)

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
    
    func headConfigure(data: Curation) {
        textLabel.text = data.headText
        dividerView.alpha = 0
    }
    
    func infoConfigure(data: Curation) {
        textLabel.text = data.infoText
        dividerView.alpha = 1
    }
}
