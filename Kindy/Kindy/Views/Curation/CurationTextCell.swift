//
//  CurationInfoCell.swift
//  Kindy
//
//  Created by rbwo on 2022/10/25.
//

import UIKit

class CurationTextCell: UICollectionViewCell {
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = .body2
        view.textAlignment = .left
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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)

        layoutAttributes.frame = frame
        
        return layoutAttributes
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        
        self.addSubview(textView)
     
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func headConfigure(data: Curation) {
        textView.text = data.headText
    }
}
