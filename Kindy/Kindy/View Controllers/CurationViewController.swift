//
//  CurationViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

class CurationViewController: UIViewController {

    // 나중에 Data를 받아온다면 생성자를 수정해서 id 값을 받아오면 될듯
    let mainView = CurationMainView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureGradient()
    }
    
    func configureGradient() {
        let gradientSize = CGRect(x: 0, y: 0 , width: mainView.bounds.width , height: (mainView.bounds.height))
        
        let gradient = gradientView(bounds: gradientSize, colors: [UIColor(red: 185/255, green: 147/255, blue: 100/255, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor])
        mainView.layer.insertSublayer(gradient, at: 1)
    }
    
    private func configureUI() {
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.rightAnchor.constraint(equalTo: view.rightAnchor),
            // 밑의 collectionView 가 만들어지면 collectionView.bottomAnchor로 바꾸기
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400),
            mainView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])

    }
}
