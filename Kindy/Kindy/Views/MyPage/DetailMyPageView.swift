//
//  DetailMyPageView.swift
//  Kindy
//
//  Created by baek seohyeon on 2022/10/25.
//

import UIKit

final class DetailMyPageView: UIView {

    var detailString: String? {
        didSet {
            detailTextView.text = detailString
        }
    }
    
    private var detailTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(detailTextView)
        
        NSLayoutConstraint.activate([
            detailTextView.topAnchor.constraint(equalTo: topAnchor, constant: 107),
            detailTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ])
    }
    
}
