//
//  UITableView+.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//

import UIKit

extension UITableView {
    func setEmptyView(text message: String) {
        let emptyView = EmptyView()
        emptyView.emptyViewMessage = message
        emptyView.reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)

        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    @objc func reportButtonTapped() {
        
    }
}
