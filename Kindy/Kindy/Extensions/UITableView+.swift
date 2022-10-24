//
//  UITableView+.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//

import UIKit

extension UITableView {
    func setEmptyView(text message: String) {
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
            label.textAlignment = .center
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let reportButton: UIButton = {
            let btn = UIButton()
            btn.setTitle("독립서점 제보하기", for: .normal)
            btn.setTitleColor(UIColor(red: 0.173, green: 0.459, blue: 0.355, alpha: 1), for: .normal)
            btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
            btn.setUnderline()
            
            return btn
        }()
        
        let emptyView : UIView = {
            let view = UIView()
            [messageLabel, reportButton].forEach{ view.addSubview($0) }
            NSLayoutConstraint.activate([
                messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                messageLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 200),  // TODO: 서치바 기준으로 잡기
                reportButton.centerXAnchor.constraint(equalTo: messageLabel.centerXAnchor),
                reportButton.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: 26)
            ])
            
            return view
        }()
        
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    // TODO: '독립서점 제보하기' 버튼 액션 구현 (메일 앱으로 넘어가기)
    @objc func reportButtonTapped() {
        print("메일 앱으로 넘어가는 기능 구현하기")
    }
}
