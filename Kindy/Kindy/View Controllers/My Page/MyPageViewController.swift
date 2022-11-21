//
//  MyPageViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/17.
//

import UIKit

// TODO: 들어올 때 로딩뷰 뜨면 좋을듯
// TODO: 프로퍼티명 수정 및 코드 정리해놓겠습니다
final class MyPageViewController: UIViewController {
    
    // MARK: Properties
    private var userRequestTask: Task<Void, Never>?
    private var bookstoresRequestTask: Task<Void, Never>?
    
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
                cellTitle = loginTitle
            } else {
                cellTitle = logoutTitle
            }
        }
    }
    private var bookmarkedBookstores: [Bookstore] = []
    
    private let userInfoContainerView: UserInfoContainerView = {
        let view = UserInfoContainerView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "kindyLightGray2")?.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tryLoginContainerView: TryLoginContainerView = {
        let view = TryLoginContainerView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "kindyLightGray2")?.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        setupAddTarget()
        tabBarController?.tabBar.isHidden = false
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
    
    private func setupUI() {
        view.addSubview(tableView)
        
        UserManager().isLoggedIn() ? setupContainerView(userInfoContainerView) : setupContainerView(tryLoginContainerView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
        ])
        
    }
    
    private func setupContainerView(_ containerView: UIView) {
        tableView.tableHeaderView = containerView
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: tableView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding16),
            containerView.heightAnchor.constraint(equalToConstant: 190)
        ])
        
        tableView.tableHeaderView?.layoutIfNeeded()
    }
    
    private func setupAddTarget() {
        userInfoContainerView.nicknameEditButton.addTarget(self, action: #selector(nicknameEditButtonTapped), for: .touchUpInside)
        userInfoContainerView.bookmarkedBookstoreButton.addTarget(self, action: #selector(bookmarkedBookstoreButtonTapped), for: .touchUpInside)
        tryLoginContainerView.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
//        tryLoginContainerView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    private func updateUserData() {
        userRequestTask?.cancel()
        bookstoresRequestTask?.cancel()
        
        // 로그인 검사
        switch UserManager().isLoggedIn() {
        // 로그인 되었을때 유저 fetch해와서 UI 수정
        case true:
            userRequestTask = Task {
                guard let user = try? await UserManager().fetchCurrentUser() else {
                    userRequestTask = nil
                    return
                }
                self.user = user
                cellTitle = loginTitle
                setupContainerView(userInfoContainerView)
                userInfoContainerView.user = user
                
                // 해당 유저의 북마크한 서점 fetch
                bookstoresRequestTask = Task {
                    guard let bookstores = try? await BookstoreRequest().fetch() else {
                        bookstoresRequestTask = nil
                        return
                    }
                    self.bookmarkedBookstores = bookstores.filter{ user.bookmarkedBookstores.contains($0.id) }
                    bookstoresRequestTask = nil
                }
                userRequestTask = nil
            }
            
        // 로그인 안되어있을때 UI로 수정
        case false:
            cellTitle = logoutTitle
            setupContainerView(tryLoginContainerView)
        }
    }
    
    // MARK: Actions
    @objc func nicknameEditButtonTapped() {
        let editNicknameVC = EditNicknameViewController()
        show(editNicknameVC, sender: nil)
    }
    
    @objc func bookmarkedBookstoreButtonTapped() {
        let bookmarkVC = BookmarkViewController()
        bookmarkVC.setupData(items: bookmarkedBookstores)
        show(bookmarkVC, sender: nil)
    }
    
    @objc func signInButtonTapped() {
        let signInViewcontroller = SignInViewController()
        self.navigationController?.pushViewController(signInViewcontroller, animated: true)
    }
    
//    @objc func signUpButtonTapped() {
//        let signUpViewcontroller = SignUpViewController()
//        self.navigationController?.pushViewController(signUpViewcontroller, animated: true)
//    }
}

// MARK: Extensions
// MARK: UITableViewDataSource
extension MyPageViewController: UITableViewDataSource {
    
    // 섹션 헤더 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))
        
        let label = UILabel()
        label.frame = CGRect.init(x: padding16, y: (padding16 * 2), width: sectionHeaderView.frame.width, height: sectionHeaderView.frame.height)
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
    
    // 섹션 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellTitle.count
    }
    
    // 셀 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell else { return UITableViewCell() }
        
        cell.myPageCellLabel.text = cellTitle[indexPath.section][indexPath.row]
        
        // 회원탈퇴 셀의 경우 텍스트 색깔 빨간색으로 변경
        switch cellTitle[indexPath.section][indexPath.row] {
        case "회원탈퇴":
            cell.myPageCellLabel.textColor = .red
        default:
            cell.myPageCellLabel.textColor = .black
        }
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch cellTitle[indexPath.section][indexPath.row] {
            
        case "독립서점 제보하기":
            tableView.reportButtonTapped()
            
        case "의견 보내기":
            tableView.feedbackButtonTapped()
            
        case "이용약관":
            let policySheetViewController = PolicySheetViewController()
            policySheetViewController.fromMyPage = true
            policySheetViewController.setupLabelTitle("이용약관")
            show(policySheetViewController, sender: nil)
            
        case "개인정보 처리방침":
            let policySheetViewController = PolicySheetViewController()
            policySheetViewController.fromMyPage = true
            policySheetViewController.setupLabelTitle("개인정보 처리방침")
            show(policySheetViewController, sender: nil)
            
        case "오픈소스 라이선스":
            let policySheetViewController = PolicySheetViewController()
            policySheetViewController.fromMyPage = true
            policySheetViewController.setupLabelTitle("오픈소스 라이선스")
            show(policySheetViewController, sender: nil)
            
        case "로그아웃":
            let alertForSignOut = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
            let action = UIAlertAction(title: "로그아웃", style: .destructive, handler: { _ in
                UserManager().signOut()
                self.user = nil
                self.setupContainerView(self.tryLoginContainerView)
            })
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alertForSignOut.addAction(cancel)
            alertForSignOut.addAction(action)
            
            present(alertForSignOut, animated: true) {
                tableView.reloadData()
            }
            
        case "회원탈퇴":
            let alertForDeleteUser = UIAlertController(title: "Kindy 회원 탈퇴하기", message: "탈퇴하더라도 삭제하지 않은\n작성 글과 댓글은 유지됩니다.\n그래도 정말 탈퇴하시겠습니까?", preferredStyle: .alert)
            let action = UIAlertAction(title: "탈퇴하기", style: .destructive, handler: { _ in
                UserManager().delete()
                self.user = nil
                self.setupContainerView(self.tryLoginContainerView)
            })
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alertForDeleteUser.addAction(cancel)
            alertForDeleteUser.addAction(action)
            present(alertForDeleteUser, animated: true) {
                tableView.reloadData()
            }
            
        default:
            print("TableView Delegate Error!")
            break
        }
    }
    
}
