//
//  CurationDetailCell.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

final class CurationDetailCell: UICollectionViewCell {
    private lazy var spacingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "testImage")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 17, weight: .light)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 17, weight: .light)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.configure()
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
    
    private func configureUI() {
        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        self.addSubview(imageView)
        self.addSubview(descriptionLabel)
        self.addSubview(spacingView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            spacingView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            spacingView.heightAnchor.constraint(equalToConstant: 30),
            spacingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            spacingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    func calHeight() -> CGFloat {
        return [titleLabel, descriptionLabel, imageView].map { view in
            view.frame.size.height
        }.reduce(into: 0) { partialResult, CGFloat in
            partialResult += CGFloat
        }
    }

    func configure() {
        titleLabel.text = "📚 두두디북스 | 부산 수영구 \n\n✏️ 출입문부터 시작해 내부 인테리어까지 프라이빗한 아지트에 온 것 같은 느낌이 들었다.  공간이 생각보다 굉장히 넓었고, 펍 운영 공간은 이전에 생각하던 서점 분위기와는 반전되는 느낌이라 신선하고 재밌었다.  2016년부터 계속 자리를 지키고 있는 만큼 ‘만남’에 진심인 이 곳에서는 굉장히 다양한 클래스들을 개최하고 있어 부산에 계신 분이라면 시간을 내어 참여해봐도 좋을 것 같다"
        
        descriptionLabel.text = "⏰ 주중 무인 운영(월-금) \n⏰ 주말 오후 1시-7시 \n📍 부산광역시 수영구 수영로510번길 43 (광안동, 광남빌라) 지하 1층 \n💬 @doodoodibooks"
    }
}
