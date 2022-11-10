//
//  MyPageViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/17.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    private let privacy = Privacy()
    // 라이선스를 추가해야하는 경우 라이선스랑 제보하기의 배열 내부 위치를 바꿔주시면 됩니다
    private let cellTitle: [String] = ["독립서점 제보하기", "북마크 한 서점", "개인정보 처리방침", "라이선스"]
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        //테이블 뷰 셀 separator 왼쪽 여백 없애기
        tableView.separatorInset.left = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        navigationController?.navigationBar.topItem?.title = "마이페이지"
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 56
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageTableViewCell")
    }
    
    private func setupUI() {
        view.addSubview(tableView)
    
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }

}

extension MyPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell else { return UITableViewCell() }
        cell.myPageCellLabel.text = cellTitle[indexPath.row]
        
        if cell.myPageCellLabel.text == "개인정보 처리방침" || cell.myPageCellLabel.text == "라이선스" || cell.myPageCellLabel.text == "북마크 한 서점"  {
            cell.isHidden = true
        }
        return cell
    }
    
}

extension MyPageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        switch cellTitle[indexPath.row] {
        case "북마크 한 서점":
//            let bookmarkVC = BookmarkViewController()
//            bookmarkVC.setupData(items: NewItems.bookstoreDummy.filter{ $0.isFavorite })
//            show(bookmarkVC, sender: nil)
//            tableView.deselectRow(at: indexPath, animated: true)
            return
        case "개인정보 처리방침":
            let detailMyPageVC = DetailMyPageViewController()
            detailMyPageVC.navigationBarTitle = "개인정보 처리방침"
            detailMyPageVC.detailString = privacy.termsOfService
            show(detailMyPageVC, sender: nil)

        case "라이선스":
            let detailMyPageVC = DetailMyPageViewController()
            detailMyPageVC.navigationBarTitle = "라이선스"
            detailMyPageVC.detailString = privacy.license
            show(detailMyPageVC, sender: nil)

        case "독립서점 제보하기":
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reportButtonTapped()

        default:
            print("TableView Delegate Error!")
            break
        }

    }

}
