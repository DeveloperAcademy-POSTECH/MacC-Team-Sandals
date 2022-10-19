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
    
    // 검색된 프로퍼티 담을 배열 생성 (초기값은 전체가 담겨있는 배열) -> 이 기준으로 cell 나타낼 것이기 때문에 DataSource, Delegate에 이 프로퍼티 적용
    var filteredItems: [BookStore] = []
    
    // MARK: - 라이프 사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - 메소드
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(NearbyCell.self, forCellReuseIdentifier: NearbyCell.reuseID)   // Cell 등록 (코드 베이스라서)
        tableView.rowHeight = NearbyCell.rowHeight
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

extension NearbyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NearbyCell.reuseID, for: indexPath) as! NearbyCell
        cell.bookStore = filteredItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredItems.count == 0 ? nil : "총 \(filteredItems.count)개"
    }
}
