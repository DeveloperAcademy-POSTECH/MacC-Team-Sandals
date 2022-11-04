//
//  CurationHeaderView2.swift
//  Kindy
//
//  Created by rbwo on 2022/10/23.
//

import UIKit

class CurationHeaderView: UIView {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .title2
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .title3
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   
    init(frame: CGRect, curation: Curation) {
        super.init(frame: frame)
        self.configureUI()
        self.configureData(curationData: curation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        
        let defaultHeight: CGFloat = (0.65 * screenHeight + 96.5) - (0.52 * screenHeight)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -defaultHeight),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
    
    // TODO: Model이 들어오면 수정해야함
    private func configureData(curationData: Curation) {
        self.imageView.image = UIImage(named: curationData.mainImage)
        self.titleLabel.text = curationData.title
        self.subtitleLabel.text = curationData.subTitle
    }
}
