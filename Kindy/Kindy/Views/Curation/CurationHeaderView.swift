//
//  CurationMainView.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

final class CurationHeaderView: UICollectionViewCell {
    
    let mockData = CurationHeader(id: "testData", title: "바쁜 일상,", subTitle: "잠시 쉬어갈 장소가 필요한 분들에게")
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "testImage")
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 25, weight: .bold)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 17, weight: .light)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.createGradient()
        self.configureData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
    
    private func createGradient() {
        let gradientSize = CGRect(x: 0, y: 0 , width: self.bounds.width , height: self.bounds.height + 200)
        let gradient = gradientView(bounds: gradientSize ,colors: [UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor])
        self.layer.insertSublayer(gradient, at: 1)
    }
    
    // TODO: Model이 들어오면 수정해야함
    private func configureData() {
        self.titleLabel.text = mockData.title
        self.subtitleLabel.text = mockData.subTitle
    }
}

