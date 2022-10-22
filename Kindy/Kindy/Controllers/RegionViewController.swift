//
//  RegionViewController.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//

import UIKit

class RegionViewController: UIViewController {

    private var tableView = UITableView()
    
    private var filteredItems: [Dummy] = dummyList
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
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

// MARK: - DataSource

extension RegionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count == 0 ? tableView.setEmptyView(text: "찾으시는 서점이 없으신가요?") : tableView.restore()
        
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RegionCell.identifier, for: indexPath) as? RegionCell else { return UITableViewCell() }
        cell.bookstore = filteredItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredItems.count == 0 ? nil : "총 \(filteredItems.count)개"
    }
}
