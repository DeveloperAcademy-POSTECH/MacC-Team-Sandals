//
//  CheckPolicyUIView.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/09.
//

import UIKit

class CheckPolicyUIView: UIView {
    
    weak var delegate: SignUpDelegate?
    
    private var isTotalChecked: Bool = false {
        didSet {
            delegate?.isToggle(isTotalChecked)
        }
    }
    private var isFirstChecked: Bool = false
    private var isSecondChecked: Bool = false

    private let totalCheckView: CheckboxUIView = {
        let view = CheckboxUIView()
        view.position = "total"
        view.setupTitle(type: "main", title: "전체 약관 동의")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let firstCheckView: CheckboxUIView = {
        let view = CheckboxUIView()
        view.position = "first"
        view.setupTitle(type: "sub", title: "(필수) 회원가입 및 운영 약관 동의")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let secondCheckView: CheckboxUIView = {
        let view = CheckboxUIView()
        view.position = "second"
        view.setupTitle(type: "sub", title: "(필수) 개인정보 수집 및 이용 동의")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.layer.cornerRadius = 8
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor.kindyGray?.cgColor
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        setupTotalCheckView()
        setupSubStackView()
        
    }
    
    
    
    private func setupTotalCheckView()  {
        addSubview(totalCheckView)
        NSLayoutConstraint.activate([
            totalCheckView.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalCheckView.topAnchor.constraint(equalTo: topAnchor),
            totalCheckView.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalCheckView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupSubStackView() {
        totalCheckView.delegate = self
        firstCheckView.delegate = self
        secondCheckView.delegate = self
        subStackView.addArrangedSubview(firstCheckView)
        subStackView.addArrangedSubview(secondCheckView)
        addSubview(subStackView)
        NSLayoutConstraint.activate([
            firstCheckView.heightAnchor.constraint(equalToConstant: 20),
            secondCheckView.heightAnchor.constraint(equalToConstant: 20),
            subStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subStackView.topAnchor.constraint(equalTo: totalCheckView.bottomAnchor, constant: 16),
            subStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            subStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        
    }

}

extension CheckPolicyUIView: CheckPolicyDelegate {
    func policySheetOpen(_ title: String) {
        self.delegate?.policySheetOpen(title)
    }
    
    
    func isTotalToogle() {
        isTotalChecked.toggle()
        if isTotalChecked {
            isFirstChecked = true
            isSecondChecked = true
            firstCheckView.isChecked = true
            secondCheckView.isChecked = true
            totalCheckView.isChecked = true
        } else {
            isFirstChecked = false
            isSecondChecked = false
            firstCheckView.isChecked = false
            secondCheckView.isChecked = false
            totalCheckView.isChecked = false
        }
    }
    func isFirstToggle() {
        firstCheckView.isChecked.toggle()
        isFirstChecked = firstCheckView.isChecked
        if isFirstChecked && isSecondChecked {
            self.isTotalChecked = true
            totalCheckView.isChecked = true
        } else {
            self.isTotalChecked = false
            totalCheckView.isChecked = false
        }
    }
    
    func isSecondToggle() {
        secondCheckView.isChecked.toggle()
        isSecondChecked = secondCheckView.isChecked
        if isFirstChecked && isSecondChecked {
            self.isTotalChecked = true
            totalCheckView.isChecked = true
        } else {
            self.isTotalChecked = false
            totalCheckView.isChecked = false
        }
    }
}
