//
//  CurationListViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/11/08.
//

import UIKit

final class CurationListViewController: UIViewController {

    // MARK: - 프로퍼티

    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createBarButtonItems()
    }
    
    // MARK: - 메소드
    
    private func createBarButtonItems() {
        let scaledImage = UIImage(named: "KindyLogo")?.resizeImage(size: CGSize(width: 80, height: 20)).withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: scaledImage, style: .plain, target: nil, action: nil)
        
        let bellButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(bellButtonTapped))
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        
        bellButton.tintColor = .black
        searchButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [bellButton, searchButton]
    }
    
    @objc func searchButtonTapped() {
//        let homeSearchViewController = HomeSearchViewController()
//        show(homeSearchViewController, sender: nil)
    }
    
    @objc func bellButtonTapped() {
        
    }
    
}
