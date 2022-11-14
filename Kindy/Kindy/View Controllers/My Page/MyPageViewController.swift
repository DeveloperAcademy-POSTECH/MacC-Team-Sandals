//
//  MyPageViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/17.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    private let firestoreManager = FirestoreManager()
    private var bookstoresRequestTask: Task<Void, Never>?
    private var userRequestTask: Task<Void, Never>?
    
    private var bookmarkedBookstores:[Bookstore] = []
    private var user: User? {
        didSet {
            if let _ = user {
                cellTitle = logoutTitle
            } else {
                cellTitle = loginTitle
            }
        }
    }
    
    private let privacy = Privacy()
    // 라이선스를 추가해야하는 경우 라이선스랑 제보하기의 배열 내부 위치를 바꿔주시면 됩니다
    private var cellTitle: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private let loginTitle: [String] = ["북마크 한 서점", "독립서점 제보하기", "개인정보 처리방침", "라이선스", "로그인"]
    private let logoutTitle: [String] = ["북마크 한 서점", "독립서점 제보하기", "개인정보 처리방침", "라이선스", "로그아웃", "회원탈퇴"]
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        updateUserData()
    }

    private func updateUserData() {
        userRequestTask?.cancel()
        userRequestTask = Task {
            if firestoreManager.isLoggedIn() {
                if let user = try? await firestoreManager.fetchCurrentUser() {
                    self.user = user
                    bookstoresRequestTask = Task {
                        if let bookstores = try? await firestoreManager.fetchBookstores() {
                            self.bookmarkedBookstores = bookstores.filter{ user.bookmarkedBookstores.contains($0.id) }
                            self.cellTitle = logoutTitle
                        }
                        bookstoresRequestTask = nil
                    }
                }
            } else {
                cellTitle = loginTitle
            }
            userRequestTask = nil
            tableView.reloadData()
        }
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
        if indexPath.row == 5 {
            cell.myPageCellLabel.textColor = .red
        } else {
            cell.myPageCellLabel.textColor = .black
        }
        return cell
    }
    
}

extension MyPageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        switch cellTitle[indexPath.row] {
        case "북마크 한 서점":
            if let _ = user {
                let bookmarkVC = BookmarkViewController()
                bookmarkVC.setupData(items: bookmarkedBookstores)
                show(bookmarkVC, sender: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                let alertForSignIn = UIAlertController(title: "로그인이 필요한 기능입니다", message: "로그인하시겠습니까?", preferredStyle: .alert)
                let action = UIAlertAction(title: "네", style: .default, handler: { _ in
                    let signInViewController = SignInViewController()
                    self.navigationController?.pushViewController(signInViewController, animated: true)
                })
                let cancel = UIAlertAction(title: "아니오", style: .cancel)
                alertForSignIn.addAction(cancel)
                alertForSignIn.addAction(action)
                present(alertForSignIn, animated: true, completion: nil)
            }
        case "개인정보 처리방침":
//            let detailMyPageVC = DetailMyPageViewController()
//            detailMyPageVC.navigationBarTitle = "개인정보 처리방침"
//            detailMyPageVC.detailString = privacy.termsOfService
//            show(detailMyPageVC, sender: nil)
            let policySheetViewController = PolicySheetViewController()
            policySheetViewController.fromMyPage = true
            policySheetViewController.setupLabelTitle("개인정보 처리방침")
            show(policySheetViewController, sender: nil)
        case "라이선스":
//            let detailMyPageVC = DetailMyPageViewController()
//            detailMyPageVC.navigationBarTitle = "라이선스"
//            detailMyPageVC.detailString = privacy.license
//            show(detailMyPageVC, sender: nil)
            let policySheetViewController = PolicySheetViewController()
            policySheetViewController.fromMyPage = true
            policySheetViewController.setupLabelTitle("라이선스")
            show(policySheetViewController, sender: nil)
        case "독립서점 제보하기":
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reportButtonTapped()        
        case "로그인":
            let signInViewcontroller = SignInViewController()
            self.navigationController?.pushViewController(signInViewcontroller, animated: false)
        case "로그아웃":
            let alertForSignIn = UIAlertController(title: "정말 로그아웃하시겠습니까?", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "로그아웃", style: .destructive, handler: { _ in
                self.firestoreManager.signOut()
                self.user = nil
            })
            let cancel = UIAlertAction(title: "아니오", style: .cancel)
            alertForSignIn.addAction(cancel)
            alertForSignIn.addAction(action)
            present(alertForSignIn, animated: true, completion: nil)
        case "회원탈퇴":
            let alertForSignIn = UIAlertController(title: "회원탈퇴", message: "정말 회원 탈퇴를 진행하시겠습니까?", preferredStyle: .alert)
            let action = UIAlertAction(title: "네", style: .destructive, handler: { _ in
                self.firestoreManager.deleteUser()
                self.user = nil
            })
            let cancel = UIAlertAction(title: "아니오", style: .cancel)
            alertForSignIn.addAction(cancel)
            alertForSignIn.addAction(action)
            present(alertForSignIn, animated: true, completion: nil)
        default:
            print("TableView Delegate Error!")
            break
        }

    }

}
