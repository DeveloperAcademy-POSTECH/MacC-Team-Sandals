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

    // MARK: - 라이프 사이클
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
