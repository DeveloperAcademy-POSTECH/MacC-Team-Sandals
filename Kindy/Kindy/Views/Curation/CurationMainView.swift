//
//  CurationMainView.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

class CurationMainView: UIView {
    
    let mockData = CurationMain(id: "testData", mainImage: "testImage", title: "테스트를 해볼까요", subTitle: "좋아용 좋아용 좋아용좋아용좋아용")
    
    private lazy var mainImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var title: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .label
        view.font = .systemFont(ofSize: 24, weight: .heavy)
        view.numberOfLines = 1
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var subTitle: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .label
        view.font = .systemFont(ofSize: 17, weight: .light)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureUI()
        self.configureData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(mainImage)
        self.addSubview(title)
        self.addSubview(subTitle)
        
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: self.topAnchor),
            mainImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            mainImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            title.bottomAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: -100),
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 14),
            subTitle.leftAnchor.constraint(equalTo: title.leftAnchor)
        ])
    }
    
    // Model이 들어오면 수정해야함
    private func configureData() {
        self.mainImage.image = UIImage(named: mockData.mainImage)
        self.title.text = mockData.title
        self.subTitle.text = mockData.subTitle
        
    }
}

