//
//  MyActivitiesViewController.swift
//  Kindy
//
//  Created by WooriJoon on 2022/11/16.
//

import UIKit

final class MyActivitiesViewController: UIViewController {

    // MARK: Properties
    private let myActivitiesCellLabels: [String] = ["좋아요 한 글", "댓글 단 글"]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
    }
    
    // MARK: Helpers
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageTableViewCell")
        tableView.rowHeight = 56
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding16),
        ])
    }
    
}

// MARK: Extensions
// MARK: UITableViewDataSource
extension MyActivitiesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myActivitiesCellLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell else { return UITableViewCell() }
        
        cell.myPageCellLabel.text = myActivitiesCellLabels[indexPath.row]
        
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension MyActivitiesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch myActivitiesCellLabels[indexPath.row] {
        case "좋아요 한 글":
            // TODO: 좋아요 한 큐레이션 페이지 불러오기
            print("좋아요 한 글")

            // TODO: 댓글 단 큐레이션 페이지 불러오기
        case "댓글 단 글":
            print("댓글 단 글")
            
        default:
            break
        }
    }
    
}
