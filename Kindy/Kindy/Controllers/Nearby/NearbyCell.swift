//
//  NearbyCell.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/20.
//

import UIKit

class NearbyCell: UITableViewCell {

    static let reuseID = "NearMeListCell"
    static let rowHeight: CGFloat = 136     // Cell 길이

    // MARK: - Cell 프로퍼티
    
    // 서점 사진
    private let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 104),
            imageView.heightAnchor.constraint(equalToConstant: 104)
        ])
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true      // radius를 imageView에 적용
        imageView.backgroundColor = .lightGray      // 사진 없을 경우 default 색
        
        return imageView
    }()

    // 서점 이름
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 25)
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.text = ""

        return label
    }()
    
    // 서점 상세 주소
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 22)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
        label.text = ""
        
        return label
    }()
    
    // 서점까지의 거리
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 25)
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.textColor = UIColor(red: 0.173, green: 0.459, blue: 0.355, alpha: 1)
        label.text = ""
        
        return label
    }()
    
    // MARK: - 라이프 사이클
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
