//
//  RegionCollectionViewCell.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/19.
//

import UIKit

// 지역별 서점 섹션의 지역 셀
// TODO: Line view 클래스도 도 따로 만들어 보면 괜찮을듯?
class RegionCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RegionCollectionViewCell"
    
    let regionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let rightLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(regionLabel)
        addSubview(topLineView)
        addSubview(bottomLineView)
        addSubview(rightLineView)
        
        regionLabel.translatesAutoresizingMaskIntoConstraints = false
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        rightLineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            regionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            regionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            topLineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            topLineView.topAnchor.constraint(equalTo: topAnchor),
            topLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            bottomLineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            rightLineView.widthAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            rightLineView.heightAnchor.constraint(equalTo: heightAnchor),
            rightLineView.topAnchor.constraint(equalTo: topAnchor),
            rightLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightLineView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Cell
    func configureCell(_ region: Region, hideTopLine: Bool, hideRightLine: Bool) {
        regionLabel.text = region.name
        topLineView.isHidden = hideTopLine
        rightLineView.isHidden = hideRightLine
    }
}
