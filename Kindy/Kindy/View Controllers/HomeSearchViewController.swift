//
//  HomeSearchViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/23.
//

import UIKit

final class HomeSearchViewController: UIViewController {

    // MARK: - 프로퍼티
    
    private var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var filteredItems: [Dummy] = dummyList
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    // MARK: - 메소드
    
    private func setupTableView() {
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeSearchCell.self, forCellReuseIdentifier: HomeSearchCell.identifier)
        tableView.rowHeight = HomeSearchCell.rowHeight
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - data source

extension HomeSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeSearchCell.identifier, for: indexPath) as? HomeSearchCell else { return UITableViewCell() }
        
        return cell
    }
    
}

// MARK: - delegate
extension HomeSearchViewController: UITableViewDelegate {
    
}
