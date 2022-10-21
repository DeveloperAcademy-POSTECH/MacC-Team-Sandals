//
//  RegionCell.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//

import UIKit

class RegionCell: UITableViewCell {
    
    static let identifier = "RegionCell"
    static let rowHeight: CGFloat = 104     // Cell 길이
    
    // MARK: - 프로퍼티
    
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true      // radius를 imageView에 적용
        view.backgroundColor = .lightGray      // 사진 없을 경우 default 색
        
        return view
    }()
    
    private let infoStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .leading
        view.axis = .vertical
        view.spacing = 7   // 피그마에 적혀있는 4 적용하니 좁아보임. 7로 적용하니 피그마에 있는 비율과 비슷
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.text = ""

        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.textColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
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
