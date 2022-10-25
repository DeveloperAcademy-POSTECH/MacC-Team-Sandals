//
//  DetailMyPageViewController.swift
//  Kindy
//
//  Created by baek seohyeon on 2022/10/24.
//

import UIKit

final class DetailMyPageViewController: UIViewController {
    
    private var detailMyPageView = DetailMyPageView()
    
    var detailString: String = ""
    var navigationBarTitle: String = ""
    
    override func loadView() {
        view = detailMyPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupNavigation()
    }
    
    private func setupLabel() {
        detailMyPageView.detailString = detailString
    }
    
    private func setupNavigation() {
        navigationItem.title = navigationBarTitle
        navigationController?.navigationBar.tintColor = UIColor(named: "kindyGreen")
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }

}
