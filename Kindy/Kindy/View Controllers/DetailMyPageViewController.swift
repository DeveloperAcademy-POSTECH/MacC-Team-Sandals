//
//  DetailMyPageViewController.swift
//  Kindy
//
//  Created by baek seohyeon on 2022/10/24.
//

import UIKit

final class DetailMyPageViewController: UIViewController {
    
    var navigationBarTitle: String = ""
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 107),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    
    private func setupNavigation() {
        navigationItem.title = navigationBarTitle
        navigationController?.navigationBar.tintColor = UIColor(named: "kindyGreen")
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }

}
