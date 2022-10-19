//
//  NearbyViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/19.
//

import UIKit

class NearbyViewController: UIViewController {

    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - 메소드
    
    func setupTableView() {
        view.addSubview(tableView)
    }

}
