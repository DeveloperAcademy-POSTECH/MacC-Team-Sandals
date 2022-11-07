//
//  EmptyView.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/26.
//

import UIKit

final class EmptyView: UIView {
    
    var emptyViewMessage: String? {
        didSet {
            configure(message: emptyViewMessage!)
        }
    }
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .body2
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let reportButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("독립서점 제보하기", for: .normal)
        btn.setTitleColor(.kindyPrimaryGreen, for: .normal)
        btn.titleLabel?.font = .headline
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setUnderline()
        
        return btn
    }()
    
    private let emptyView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - 라이프 사이클
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 메소드
    
    private func setupView() {
        [messageLabel, reportButton].forEach{ emptyView.addSubview($0) }
        self.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: emptyView.topAnchor, constant: 200),  // TODO: 서치바 기준으로 잡기
            
            reportButton.centerXAnchor.constraint(equalTo: messageLabel.centerXAnchor),
            reportButton.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: 26),
            
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.topAnchor.constraint(equalTo: topAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

    }
    
    private func configure(message: String) {
        messageLabel.text = message
    }
    
}
