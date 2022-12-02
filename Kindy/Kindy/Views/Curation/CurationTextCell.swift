//
//  CurationTextCell.swift
//  Kindy
//
//  Created by rbwo on 2022/10/25.
//

import UIKit

// dividerView는 BookStoreCell을 사용하는 날이 온다면 부활시키겠습니다.

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
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = .body2
        view.textAlignment = .left
        view.isScrollEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

//    private lazy var dividerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .kindyLightGray
//        view.alpha = 0
//        return view
//    }()

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

        viewSize = NSString(string: textView.text!).boundingRect(with: maxSize,options: heightOnFont, attributes: [.font: UIFont.body2!], context: nil)
        
        viewSize.size.width = UIScreen.main.bounds.width
        viewSize.size.height += 80
        
        layoutAttributes.frame = viewSize
        return layoutAttributes
    }

    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(stackView)
        stackView.addArrangedSubview(textView)
//        stackView.addArrangedSubview(dividerView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            textView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor), 

//            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            dividerView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }

    func headConfigure(data: Curation) {
        textView.text = data.headText
//        dividerView.alpha = 0
    }
}
