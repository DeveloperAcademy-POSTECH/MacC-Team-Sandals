//
//  MyPageViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/17.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    // MARK: Properties
    private let firestoreManager = FirestoreManager()
    private var bookstoresRequestTask: Task<Void, Never>?
    private var userRequestTask: Task<Void, Never>?
    
    // 라이선스를 추가해야하는 경우 라이선스랑 제보하기의 배열 내부 위치를 바꿔주시면 됩니다
    private var cellTitle: [[String]] = [[]] {
        didSet {
            tableView.reloadData()
        }
    }
    private let loginTitle: [[String]] = [["독립서점 제보하기", "의견 보내기"],
                                          ["이용약관", "개인정보 처리방침", "오픈소스 라이선스"],
                                          ["로그아웃", "회원탈퇴"]]
    private let logoutTitle: [[String]] = [["독립서점 제보하기", "의견 보내기"],
                                           ["이용약관", "개인정보 처리방침", "오픈소스 라이선스"]]
    
    private let privacy = Privacy()
    
    private var user: User? {
        didSet {
            if let _ = user {
                cellTitle = logoutTitle
            } else {
                cellTitle = loginTitle
            }
        }
    }
    private var bookmarkedBookstores: [Bookstore] = []
    
    private let userInfoContainerView: UIView = {
        let view = UserInfoContainerView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tryLoginContainerView: UIView = {
        let view = TryLoginContainerView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        //테이블 뷰 셀 separator 왼쪽 여백 없애기
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        navigationController?.navigationBar.topItem?.title = "마이페이지"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUserData()
    }

    // MARK: Helpers
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 56
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    // TODO: userContainerView와 tryLoginContainerView 구분 로직 작성
    private func setupUI() {
        view.addSubview(tableView)
        tableView.tableHeaderView = userInfoContainerView
        
        userInfoContainerView.layer.cornerRadius = 8
        userInfoContainerView.layer.borderWidth = 1
        userInfoContainerView.layer.borderColor = UIColor(named: "kindyLightGray2")?.cgColor
        
        tryLoginContainerView.layer.cornerRadius = 8
        tryLoginContainerView.layer.borderWidth = 1
        tryLoginContainerView.layer.borderColor = UIColor(named: "kindyLightGray2")?.cgColor
    
        NSLayoutConstraint.activate([
            userInfoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding16),
            userInfoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding16),
            userInfoContainerView.heightAnchor.constraint(equalToConstant: 190),
            
//            tryLoginContainerView.widthAnchor.constraint(equalToConstant: view.frame.width - (16 * 2)),
//            tryLoginContainerView.heightAnchor.constraint(equalToConstant: 190),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateUserData() {
        userRequestTask?.cancel()
        
        userRequestTask = Task {
            if firestoreManager.isLoggedIn() {
                if let user = try? await firestoreManager.fetchCurrentUser() {
                    self.user = user
                    cellTitle = loginTitle
                    bookstoresRequestTask = Task {
                        if let bookstores = try? await firestoreManager.fetchBookstores() {
                            self.bookmarkedBookstores = bookstores.filter{ user.bookmarkedBookstores.contains($0.id) }
                        }
                        bookstoresRequestTask = nil
                    }
                }
            } else {
                cellTitle = logoutTitle
            }
            userRequestTask = nil
        }
        tableView.reloadData()
    }

}

// MARK: Extensions
// MARK: UITableViewDataSource
extension MyPageViewController: UITableViewDataSource {
    
    // 섹션 헤더 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))

        let label = UILabel()
        label.frame = CGRect.init(x: padding16, y: (padding16 * 2), width: sectionHeaderView.frame.width, height: sectionHeaderView.frame.height)
//        label.backgroundColor = .green
        label.font = .systemFont(ofSize: 17, weight: .bold)
        sectionHeaderView.addSubview(label)

        switch section {
        case 0:
            label.text = "지원"
            return sectionHeaderView
        case 1:
            label.text = "정보"
            return sectionHeaderView
        case 2:
            label.text = "회원"
            return sectionHeaderView
        default:
            return UIView()
        }
    }

    // 섹션 헤더의 Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // 섹션 헤더뷰(레이블)의 높이 25 + 섹션 간의 스페이싱 32
        return (25 + 32)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell else { return UITableViewCell() }
        
        cell.myPageCellLabel.text = cellTitle[indexPath.section][indexPath.row]
        
//        if indexPath.row == 5 {
//            cell.myPageCellLabel.textColor = .red
//        } else {
//            cell.myPageCellLabel.textColor = .black
//        }
        
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        switch cellTitle[indexPath.row] {
//        case "북마크 한 서점":
//            if let _ = user {
//                let bookmarkVC = BookmarkViewController()
//                bookmarkVC.setupData(items: bookmarkedBookstores)
//                show(bookmarkVC, sender: nil)
//                tableView.deselectRow(at: indexPath, animated: true)
//            } else {
//                let alertForSignIn = UIAlertController(title: "로그인이 필요한 기능입니다", message: "로그인하시겠습니까?", preferredStyle: .alert)
//                let action = UIAlertAction(title: "네", style: .default, handler: { _ in
//                    let signInViewController = SignInViewController()
//                    self.navigationController?.pushViewController(signInViewController, animated: true)
//                })
//                let cancel = UIAlertAction(title: "아니오", style: .cancel)
//                alertForSignIn.addAction(cancel)
//                alertForSignIn.addAction(action)
//                present(alertForSignIn, animated: true, completion: nil)
//            }
//        case "개인정보 처리방침":
////            let detailMyPageVC = DetailMyPageViewController()
////            detailMyPageVC.navigationBarTitle = "개인정보 처리방침"
////            detailMyPageVC.detailString = privacy.termsOfService
////            show(detailMyPageVC, sender: nil)
//            let policySheetViewController = PolicySheetViewController()
//            policySheetViewController.fromMyPage = true
//            policySheetViewController.setupLabelTitle("개인정보 처리방침")
//            show(policySheetViewController, sender: nil)
//        case "라이선스":
////            let detailMyPageVC = DetailMyPageViewController()
////            detailMyPageVC.navigationBarTitle = "라이선스"
////            detailMyPageVC.detailString = privacy.license
////            show(detailMyPageVC, sender: nil)
//            let policySheetViewController = PolicySheetViewController()
//            policySheetViewController.fromMyPage = true
//            policySheetViewController.setupLabelTitle("라이선스")
//            show(policySheetViewController, sender: nil)
//        case "독립서점 제보하기":
//            tableView.deselectRow(at: indexPath, animated: true)
//            tableView.reportButtonTapped()
//        case "로그인":
//            let signInViewcontroller = SignInViewController()
//            self.navigationController?.pushViewController(signInViewcontroller, animated: true)
//        case "로그아웃":
//            let alertForSignIn = UIAlertController(title: "정말 로그아웃하시겠습니까?", message: nil, preferredStyle: .alert)
//            let action = UIAlertAction(title: "로그아웃", style: .destructive, handler: { _ in
//                self.firestoreManager.signOut()
//                self.user = nil
//            })
//            let cancel = UIAlertAction(title: "아니오", style: .cancel)
//            alertForSignIn.addAction(cancel)
//            alertForSignIn.addAction(action)
//            present(alertForSignIn, animated: true, completion: nil)
//        case "회원탈퇴":
//            let alertForSignIn = UIAlertController(title: "회원탈퇴", message: "정말 회원 탈퇴를 진행하시겠습니까?", preferredStyle: .alert)
//            let action = UIAlertAction(title: "네", style: .destructive, handler: { _ in
//                self.firestoreManager.deleteUser()
//                self.user = nil
//            })
//            let cancel = UIAlertAction(title: "아니오", style: .cancel)
//            alertForSignIn.addAction(cancel)
//            alertForSignIn.addAction(action)
//            present(alertForSignIn, animated: true, completion: nil)
//        default:
//            print("TableView Delegate Error!")
//            break
//        }
//    }

}
