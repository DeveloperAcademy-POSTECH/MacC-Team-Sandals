//
//  MyPageViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/17.
//

import UIKit

class MyPageViewController: UIViewController {
    
    let privacy = Privacy()
    let cellTitle: [String] = ["북마크 한 서점", "이용약관", "라이선스", "독립서점 제보하기"]
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()

        self.navigationController?.navigationBar.topItem?.title = "마이페이지"
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 56
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageTableViewCell")
    }
    
    func setupUI() {
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        //테이블 뷰 라인 왼쪽 여백 없애기
        tableView.separatorInset.left = 0
    }

}

extension MyPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as! MyPageTableViewCell
        cell.myPageCellLabel.text = cellTitle[indexPath.row]
        
        return cell
    }
    
}

extension MyPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cellTitle[indexPath.row] {
        case "북마크 한 서점":
            let bookmarkVC = BookmarkViewController()
            show(bookmarkVC, sender: nil)
            
        case "이용약관":
            let detailMyPageVC = DetailMyPageViewController()
            detailMyPageVC.titleLabel.text = privacy.termsOfService

            show(detailMyPageVC, sender: nil)
            
        case "라이선스":
            let detailMyPageVC = DetailMyPageViewController()
            detailMyPageVC.titleLabel.text = privacy.license
            show(detailMyPageVC, sender: nil)
            
        case "독립서점 제보하기":
            // TODO: 메일 앱 연결하기
            break
            
        default:
            print("TableView Delegate Error!")
            break
        }
    }
    
}
