//
//  CurationInfoCell.swift
//  Kindy
//
//  Created by rbwo on 2022/10/25.
//

import UIKit

class CurationTextCell: UICollectionViewCell {
    
    private lazy var textLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 17, weight: .light)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.adjustsFontSizeToFitWidth = true
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
        self.backgroundColor = .white
        
        self.addSubview(textLabel)
     
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    func headConfigure(data: Curation) {
        textLabel.text = data.headText
    }
    
    func infoConfigure(data: Curation) {
        textLabel.text = data.infoText
    }
}
