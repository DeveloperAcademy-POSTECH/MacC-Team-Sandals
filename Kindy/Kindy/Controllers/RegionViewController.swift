//
//  RegionViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//

import UIKit

class RegionViewController: UIViewController {

    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = RegionCell.rowHeight
        tableView.register(RegionCell.self, forCellReuseIdentifier: RegionCell.identifier)   // Cell 등록 (코드 베이스라서)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
