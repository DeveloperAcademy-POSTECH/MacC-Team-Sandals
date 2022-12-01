//
//  CurationViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit
import FirebaseFirestore

protocol SetSheetDefault: AnyObject {
    func setDefaultSheet()
}

final class CurationViewController: UIViewController {
    
    private var commentListener: ListenerRegistration?
    private var curationListener: ListenerRegistration?
    
    private var commentManager = CommentRequest()
    
    private var curation: Curation
    weak var delegate: SetSheetDefault?
    
    private var setNeedsFetchCuration: Bool = false
    private var isFirstShowingView: Bool = true
    private var isPostComment: Bool = false
    private var isDeleteComment: Bool = false
    
    private var isReloadView: Bool = false {
        didSet {
            isReloadView ? handleRefreshControl() : ()
            isReloadView = false
        }
    }
    
    private var currentLongPressedCell: UICollectionViewCell?
    
    private lazy var cellCount: Int = curation.descriptions.count
    private lazy var replyCount: Int = curation.comments?.count ?? 0
    
    private let userManager = UserManager()
    private let curationManager = CurationRequest()
    
    private var imageRequestTask: Task<[UIImage],Never>?
    private var commentTask: Task<Void, Never>?
    private var curationRequestTask: Task<Void, Never>?
    private var userNameTask: Task<Void, Never>?
    
    private var images: [UIImage]
    
    //    private var bookstoresRequestTask: Task<Void, Never>?
    //    private var bookStore: Bookstore?
    
    private var collectionViewBottomConstant: CGFloat = -62
    private var collectionViewBottomContraint: NSLayoutConstraint!
    
    private var isViewingKeyboard = false
    
    private lazy var userID: String = {
        let id = userManager.getID()
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
        guard let settingView = view.settingView as? CurationButtonItemView else { return UIView() }
        settingView.menuDelegate = self
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
        
        commentListener = commentManager.fetchUpdateComments(curationID: curation.id, completion: { querySnapshot, error in
            
            if self.isFirstShowingView {
                self.curation.comments = querySnapshot?.documents.map { try! $0.data(as: Comment.self)}
                self.afterFetachComment()
                self.isFirstShowingView = false
                return
            }
            
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    try? self.curation.comments?.append(diff.document.data(as: Comment.self))
                }
                if (diff.type == .modified) {
                    print("Modified : \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    self.curation.comments = self.curation.comments?.filter { comment in
                        try! comment.id != diff.document.data(as: Comment.self).id
                    }
                }
            }
            if self.isPostComment || self.isDeleteComment {
                self.isReloadView = true
                self.isPostComment = false
                self.isDeleteComment = false
                
                return
            }
        })
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        curationListener?.remove()
        commentListener?.remove()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureRefreshControl () {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func postRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.handleRefreshControl()
        }
    }
    
    @objc private func handleRefreshControl() {
        self.hideKeyboard()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.collectionView.contentOffset.y = -60
            self.collectionView.refreshControl?.beginRefreshing()
            self.view.isUserInteractionEnabled = false
        }
        
        
        afterFetachComment()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view.isUserInteractionEnabled = true
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func delieverAction() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    private func afterFetachComment() {
        userNameTask = Task {
            self.curation.comments?.sort(by: { first, second in
                first.createdAt < second.createdAt
            })
            
            var index = 0
            for comment in self.curation.comments ?? [] {
                if comment.userNickname == nil {
                    self.curation.comments?[index].userNickname = try? await self.userManager.fetch(with: comment.userID).nickName
                }
                index += 1
            }
            
            self.replyCount = self.curation.comments?.count ?? 0
            self.changeReplyCount()
            self.collectionView.reloadData()
        }
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
        commentTask = Task {
            isPostComment = true
            curation.commentCount += 1
            let tempCuration = curation
            try? await curationManager.createComment(curationID: tempCuration.id, userID: userID, content: content, count: tempCuration.commentCount)
            commentTask = nil
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

extension CurationViewController: CommentButtonAction {
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
                                        self.curation.commentCount -= 1
                                        let tempCuration = self.curation
                                        self.isDeleteComment = true
                                        
                                        try? await self.curationManager.deleteComment(curationID: tempCuration.id, commentID: tempCuration.comments![indexPath.row].id, count: tempCuration.commentCount)
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
        replyView.countLabel.text = String(replyCount)
    }
}

extension CurationViewController: ShowingMenu, Reportable {
    func showingMenu() {
        self.hideKeyboard()
        if curation.userID == userID {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let updateAction = UIAlertAction(title: "게시글 수정", style: .default) { _ in
                self.curationRequestTask = Task {
                    var tempImages = self.images
                    let mainImage = tempImages.removeFirst()
                    let curationCreateVC = CurationCreateViewController(self.curation, mainImage, tempImages)
                    
                    curationCreateVC.newImageAndCuration = { newImages, newCuration in
                        self.curationRequestTask = Task {
                            self.curation = newCuration
                            self.cellCount = self.curation.descriptions.count
                            
                            self.images = newImages
                            
                            guard let view = self.next as? UIView, let vc = view.findViewController() as? BottomSheetViewController else { return }
                            
                            vc.changeHeaderViewDelegate?.changeHeaderView(title: self.curation.title, subtitle: self.curation.subTitle ?? "", image: self.images[0])
                            
                            self.handleRefreshControl()
                            self.curationRequestTask = nil
                        }
                    }
                    let naviVC = UINavigationController(rootViewController: curationCreateVC)
                    naviVC.modalPresentationStyle = .overFullScreen
                    self.show(naviVC, sender: nil)
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    
                    self.curationRequestTask = nil
                }
            }
            
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                let deleteAlertController = UIAlertController(title: "글을 삭제하시겠습니까?", message: "삭제된 글은 복구할 수 없습니다.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self.curationRequestTask = Task {
                        guard let view = self.next as? UIView, let vc = view.findViewController() as? BottomSheetViewController else { return }
                        
                        try? self.curationManager.deleteCurationImage(url: self.curation.mainImage)
                        
                        let _ = try? await self.curation.descriptions.concurrentMap { description in
                            try self.curationManager.deleteCurationImage(url: description.image ?? "")
                        }
                        
                        try? await self.curationManager.delete(curationID: self.curation.id)
                        
                        vc.dismissView()
                        self.curationRequestTask = nil
                    }
                }
                let cancelAction = UIAlertAction(title: "취소", style: .default)
                deleteAlertController.addAction(cancelAction)
                deleteAlertController.addAction(okAction)
                self.present(deleteAlertController, animated: true)
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alertController.addAction(updateAction)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
        else {
            showReportController(self, style: .actionSheet, title: "게시글 신고")
        }
    }
}

extension CurationViewController {
    private func refetchImages(curation: Curation) async -> [UIImage] {
        imageRequestTask = Task {
            imageRequestTask = nil
            var newImages: [UIImage] = []
            if let mainImage = try? await ImageCache.shared.load(curation.mainImage, size: ImageSize.medium) {
                newImages.append(mainImage)
            } else {
                newImages.append(UIImage())
            }
            
            let descriptionImages = try! await ImageCache.shared.loadImageArray(URLs: curation.descriptions.map { $0.image ?? "" })
            newImages.append(contentsOf: descriptionImages.map { $0 })
            return newImages
        }
        return await imageRequestTask?.value ?? []
    }
}

extension CurationViewController: UITextFieldDelegate { }
