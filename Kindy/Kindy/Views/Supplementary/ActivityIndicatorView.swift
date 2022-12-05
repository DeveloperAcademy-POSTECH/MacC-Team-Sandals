//
//  ActivityIndicatorView.swift
//  Kindy
//
//  Created by 정호윤 on 2022/12/05.
//

import UIKit

/// 로딩 중에 보여줄 인디케이터 뷰
final class ActivityIndicatorView: UIActivityIndicatorView {
    
    init() {
        super.init(frame: .zero)
        style = .large
        hidesWhenStopped = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
