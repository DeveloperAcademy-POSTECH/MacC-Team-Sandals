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
    
    // MARK: - 라이프 사이클
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
