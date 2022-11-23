//
//  CurationViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

protocol SetSheetDefault: AnyObject {
    func setDefaultSheet()
}

final class CurationViewController: UIViewController {
    
    private var listener: Any?
    
    private var curation: Curation
    
    weak var delegate: SetSheetDefault?
    
    private var currentLongPressedCell: UICollectionViewCell?

    private lazy var cellCount: Int = curation.descriptions.count
    private lazy var replyCount: Int = curation.comments?.count ?? 0

    private var updateUserNicknameTask: Task<Void, Never>?
    private var curationRequestTask: Task<Void, Never>?
    private let firestoreManager = FirestoreManager()
    private let images: [UIImage]

//    private var bookstoresRequestTask: Task<Void, Never>?
//    private var bookStore: Bookstore?

    private var collectionViewBottomConstant: CGFloat = -72
    private var collectionViewBottomContraint: NSLayoutConstraint!
    
    private var isViewingKeyboard = false
    
    private lazy var userID: String = {
        let id = firestoreManager.getUserID()
        return id
    }()

    init(curation: Curation, images: [UIImage]) {
        self.curation = curation
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var bottomView: UIView = {
        let view = CurationButtonStackView(frame: .zero, curation: curation)
        guard let replyView = view.replyView as? CurationButtonItemView else { return UIView()}
        replyView.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
// --------------
// MARK: 서점 정보 불러오는 Task
//        self.bookstoresRequestTask = Task {
//            self.bookStore = try? await firestoreManager.fetchBookstore(with: curation.bookstoreID)
//            bookstoresRequestTask = nil
//        }
// --------------
        
        listener = firestoreManager.fetchComments(curationID: curation.id) { querySnapshot, error in
            self.updateUserNicknameTask = Task {
                var index = 0
                self.curation.comments = querySnapshot?.documents.map { try! $0.data(as: Comment.self)}
                self.curation.comments?.sort(by: { first, second in
                    first.createdAt < second.createdAt
                })
                for comment in self.curation.comments ?? [] {
                    if comment.userNickname == nil {
                        self.curation.comments?[index].userNickname = try? await self.firestoreManager.fetchUserWithDocID(documentID: comment.userID).nickName
                    }
                   index += 1
                }
                self.changeReplyCount()
                self.replyCount = self.curation.comments?.count ?? 0
                self.collectionView.reloadData()
                self.updateUserNicknameTask = nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        delieverAction()
        setupLongGestureRecognizerOnCollection()
        configureCollectionView()
        configureRefreshControl()
        createLayout()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener = nil
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func configureRefreshControl () {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc private func handleRefreshControl() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.hideKeyboard()
            self.collectionView.contentOffset.y = -50
            self.collectionView.refreshControl?.beginRefreshing()
        }
        collectionView.reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func delieverAction() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
}

private extension CurationViewController {
    func configureCollectionView() {
//        collectionView.register(CurationStoreCell.self, forCellWithReuseIdentifier: CurationStoreCell.identifier)

        collectionView.register(CurationTextCell.self, forCellWithReuseIdentifier: CurationTextCell.identifier)

        collectionView.register(CurationDetailCell.self, forCellWithReuseIdentifier: CurationDetailCell.identifier)

        collectionView.register(CurationCommentCell.self, forCellWithReuseIdentifier: CurationCommentCell.identifier)

        collectionView.register(CurationCommentTextFieldCell.self, forCellWithReuseIdentifier: CurationCommentTextFieldCell.identifier)
    }

    func createLayout() {
        view.addSubview(collectionView)
        view.addSubview(bottomView)

        collectionViewBottomContraint = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: collectionViewBottomConstant)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewBottomContraint,

            bottomView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension CurationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.item == 0 {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationStoreCell.identifier, for: indexPath) as? CurationStoreCell else {
//                return UICollectionViewCell() }
//            cell.configure(bookStore: curation.bookstoreID)
//            cell.backgroundColor = .clear
//            return cell
//        } else
// --- 서점 스토어셀은 추후에 추가

        if indexPath.section == 0 {
            if indexPath.item == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationTextCell.identifier, for: indexPath) as? CurationTextCell else { return UICollectionViewCell() }
                cell.headConfigure(data: curation)
                return cell
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationDetailCell.identifier, for: indexPath) as? CurationDetailCell else { return UICollectionViewCell() }

            if indexPath.item == cellCount {
                cell.addLineView()
            } else {
                cell.removeLineView()
            }

            cell.configure(description: curation.descriptions[indexPath.item - 1], image: images[indexPath.item])
            return cell
        }

        if indexPath.item != replyCount {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationCommentCell.identifier, for: indexPath) as? CurationCommentCell else { return UICollectionViewCell() }

            cell.userLabel.text = curation.comments?[indexPath.item].userNickname
            cell.configure(data: curation.comments![indexPath.item])
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationCommentTextFieldCell.identifier, for: indexPath) as? CurationCommentTextFieldCell else { return UICollectionViewCell() }
            cell.bottomTextFieldView.delegate = self
            cell.delegate = self
            return cell
        }
    }
}
extension CurationViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return cellCount + 1
        }
        return replyCount + 1
    }

// MARK: 서점 정보 관련 action은 추후에 추가
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.item == 0 {
//            let bookstoreVC = DetailBookstoreViewController()
//            bookstoreVC.bookstore = bookStore
//            let naviVC = UINavigationController(rootViewController: bookstoreVC)
//            naviVC.modalPresentationStyle = .overFullScreen
//            show(naviVC, sender: nil)
//        }
//    }
}

extension CurationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}

extension CurationViewController: PostComment {
    func postComment(content: String) {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        try? firestoreManager.createComment(curationID: curation.id, userID: userID, content: content)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.handleRefreshControl()
        }
    }
}

extension CurationViewController: KeyboardActionable {
    @objc func keyboardWillShow(_ notification: Notification) {
        if isViewingKeyboard { return }
        
        let notiInfo = notification.userInfo!
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.height
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: animationDuration) {
            self.collectionViewBottomContraint.constant -= height - 10
            self.view.layoutIfNeeded()
        }
        isViewingKeyboard = true
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        isViewingKeyboard = false
        
        UIView.animate(withDuration: 0.1) {
            self.collectionViewBottomContraint.constant = self.collectionViewBottomConstant
            self.view.layoutIfNeeded()
        }
    }
}

extension CurationViewController: ReplyButtonAction {
    func showingKeyboard() {
        collectionView.scrollToItem(at: IndexPath(row: replyCount, section: 1), at: .bottom, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            for cell in self.collectionView.visibleCells {
                guard let textFieldCell = cell as? CurationCommentTextFieldCell else { continue }
                textFieldCell.bottomTextFieldView.becomeFirstResponder()
            }
        }
    }
}

extension CurationViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y != -60 && collectionView.contentOffset.y < -75 {
            delegate?.setDefaultSheet()
        }
    }
}

extension CurationViewController: UIGestureRecognizerDelegate {
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = false
        collectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: gestureRecognizer.view)
        let collectionView = gestureRecognizer.view as! UICollectionView
            
        if gestureRecognizer.state == .began {
            if let indexPath = collectionView.indexPathForItem(at: location) {
                UIView.animate(withDuration: 0.2) {
                    if let cell = collectionView.cellForItem(at: indexPath) as? CurationCommentCell {
                        self.currentLongPressedCell = cell
                        cell.transform = .init(scaleX: 0.99, y: 0.99)
                    }
                }
            }
        } else if gestureRecognizer.state == .ended {
            if let indexPath = collectionView.indexPathForItem(at: location) {
                UIView.animate(withDuration: 0.2) {
                    if let cell = self.currentLongPressedCell  {
                        cell.transform = .init(scaleX: 1, y: 1)
                        if cell == collectionView.cellForItem(at: indexPath) as? CurationCommentCell {
                            if self.userID == self.curation.comments![indexPath.row].userID {
                                let alertController = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                                    self.curationRequestTask = Task {
                                        self.firestoreManager.deleteComment(curationID: self.curation.id, commentID: self.curation.comments![indexPath.row].id)
                                    
                                        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                                    }
                                }
                                let cancelAction = UIAlertAction(title: "취소", style: .default)
                                
                                alertController.addAction(cancelAction)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true)
                            }
                        }
                    }
                }
            }
        } else {
            return
        }
    }
}

private extension CurationViewController {
    func changeReplyCount() {
        guard let stackView = bottomView as? CurationButtonStackView else { return }
        guard let replyView = stackView.replyView as? CurationButtonItemView else { return }
        replyView.countLabel.text = String(curation.comments?.count ?? 0)
    }
}

extension CurationViewController: UITextFieldDelegate { }
