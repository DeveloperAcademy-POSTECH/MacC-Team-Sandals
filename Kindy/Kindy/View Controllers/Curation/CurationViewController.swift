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
    private let commentManager = CommentRequest()

    private var curation: Curation
    private var comments: [Comment]?
    private var updatedComments: [Comment] = []
    weak var delegate: SetSheetDefault?

    private var isFirstShowingView: Bool = true
    private var isPostComment: Bool = false
    private var isDeleteComment: Bool = false

    private var viewNeedsReload: Bool = false {
        didSet {
            viewNeedsReload ? handleRefreshControl() : ()
            viewNeedsReload = false
        }
    }

    private var currentLongPressedCell: UICollectionViewCell?

    private lazy var cellCount: Int = curation.descriptions.count
    private lazy var replyCount: Int = comments?.count ?? 0
    private lazy var likeCount: Int = curation.likes.count
    private var serverReplyCount: Int = 0

    private let userManager = UserManager()
    private let curationManager = CurationRequest()

    private var imageRequestTask: Task<Void, Never>?
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

    private lazy var listener: ListenerRegistration = {
        return commentManager.subcollectionReference(curation.id).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")

                return
            }

            if self.isFirstShowingView {
                self.commentTask = Task {
                    self.comments = snapshot.documents.compactMap { comment in
                        try? comment.data(as: Comment.self)
                    }

                    self.updatedComments = self.comments ?? []
                    self.serverReplyCount = self.updatedComments.count
                    self.reFetch()
                    self.isFirstShowingView = false
                    self.commentTask = nil
                }

                return
            }

            snapshot.documentChanges.forEach { diff in
                switch diff.type {
                case .added:
                    try? self.updatedComments.append(diff.document.data(as: Comment.self))
                    self.serverReplyCount = self.updatedComments.count

                case .removed:
                    guard let removedComment = try? diff.document.data(as: Comment.self) else { return }

                    self.updatedComments = self.updatedComments.filter { comment in
                        comment.id != removedComment.id
                    }
                    self.serverReplyCount = self.updatedComments.count

                default:
                    return
                }
            }

            if self.isPostComment || self.isDeleteComment {
                self.viewNeedsReload = true
                self.isPostComment = false
                self.isDeleteComment = false

                return
            }
        }
    }()

    init(curation: Curation, images: [UIImage]) {
        self.curation = curation
        self.images = images
        super.init(nibName: nil, bundle: nil)
        _ = listener
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var bottomView: CurationButtonStackView = {
        let view = CurationButtonStackView(frame: .zero, curation: curation)
        let replyView = view.replyView
        replyView.delegate = self
        let settingView = view.settingView
        settingView.menuDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    // --------------
    // MARK: 서점 정보 불러오는 Task
    //        self.bookstoresRequestTask = Task {
    //            self.bookStore = try? await firestoreManager.fetchBookstore(with: curation.bookstoreID)
    //            bookstoresRequestTask = nil
    //        }
    // --------------
    //    }

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
        curationRequestTask = Task {
            if curation.commentCount != serverReplyCount {
                try? await curationManager.equalizedCommentCount(curationID: curation.id, count: serverReplyCount)
            }
            curationRequestTask = nil
        }

        listener.remove()
        NotificationCenter.default.removeObserver(self)
    }

    private func configureRefreshControl () {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc private func handleRefreshControl() {
        self.hideKeyboard()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)

        UIView.animate(withDuration: 0.5, delay: 0) {
            self.collectionView.contentOffset.y = -60
            self.collectionView.refreshControl?.beginRefreshing()
            self.view.isUserInteractionEnabled = false
        }

        reFetch()

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

    private func reFetch() {
        if !isFirstShowingView {
            curationRequestTask = Task {
                guard let newCuration = try? await curationManager.fetch(with: curation.id) else { return }

                curation = newCuration
                likeCount = curation.likes.count
                curationRequestTask = nil
            }
        }

        userNameTask = Task {
            updatedComments.sort { first, second in
                first.createdAt < second.createdAt
            }

            comments = try? await updatedComments.concurrentMap { comment in
                if comment.userNickname == nil {
                    var newComment = comment
                    newComment.userNickname = try? await self.userManager.fetch(with: comment.userID).nickName
                    return newComment
                } else { return comment }
            }

            replyCount = comments?.count ?? 0
            updatedCounts()
            collectionView.reloadData()
            userNameTask = nil
        }
    }
}

extension CurationViewController {
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
        switch (indexPath.section, indexPath.item) {
        case (0, 0):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationTextCell.identifier, for: indexPath) as? CurationTextCell else { return UICollectionViewCell() }
            cell.headConfigure(data: curation)
            return cell

        case (0, 1...):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationDetailCell.identifier, for: indexPath) as? CurationDetailCell else { return UICollectionViewCell() }

            if indexPath.item == cellCount {
                cell.addLineView()
            } else {
                cell.removeLineView()
            }

            imageRequestTask = Task {
                let curation = curation
                if let image = try? await ImageCache.shared.load(curation.descriptions[indexPath.item - 1].image) {
                    cell.imageView.image = image

                    if !images.contains(where: { $0 == image }) {
                        images.append(image)
                    }
                }
                imageRequestTask = nil
            }

            cell.configure(description: curation.descriptions[indexPath.item - 1].content ?? "")

            return cell

        case (1, 0..<replyCount):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationCommentCell.identifier, for: indexPath) as? CurationCommentCell,
                  let comments = comments else { return UICollectionViewCell() }
            cell.configure(data: comments[indexPath.item])

            return cell

        case (1, replyCount):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationCommentTextFieldCell.identifier, for: indexPath) as? CurationCommentTextFieldCell else { return UICollectionViewCell() }
            cell.bottomTextFieldView.delegate = self
            cell.delegate = self

            return cell

        default:
            return UICollectionViewCell()
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
            try? await commentManager.add(curationID: curation.id, userID: userID, content: content, count: curation.commentCount)
            try? userManager.addCommentedCuration(userID: userID, curationID: curation.id)
            commentTask = nil
        }
    }
}

extension CurationViewController: KeyboardActionable {
    @objc func keyboardWillShow(_ notification: Notification) {
        if isViewingKeyboard { return }

        guard let notiInfo = notification.userInfo else { return }
        guard let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let height = keyboardFrame.height
        guard let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

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
        guard let view = self.next as? UIView, let vc = view.findViewController() as? BottomSheetViewController else { return }
        vc.showBottomSheet(atState: .expanded)
        vc.delegate?.setTopHeaderLayout()

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
        guard let collectionView = gestureRecognizer.view as? UICollectionView else { return }
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
                            if self.userID == self.comments?[indexPath.row].userID {
                                let alertController = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)

                                let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                                    self.curationRequestTask = Task {
                                        self.curation.commentCount -= 1

                                        guard let comments = self.comments else { return }
                                        self.isDeleteComment = true

                                        try? await self.userManager.deleteCommentedCurationIfNeeded(userID: self.userID, curationID: self.curation.id)
                                        try? await self.commentManager.delete(curationID: self.curation.id, commentID: comments[indexPath.row].id, count: self.curation.commentCount)
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

extension CurationViewController {
    func updatedCounts() {
        let replyView = bottomView.replyView
        replyView.countLabel.text = String(replyCount)

        let likeView = bottomView.heartView
        likeView.countLabel.text = String(likeCount)
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
                        try? await self.userManager.deleteAllCommentedCuration(curationID: self.curation.id)

                        guard let view = self.next as? UIView, let vc = view.findViewController() as? BottomSheetViewController else { return }

                        try? self.curationManager.deleteImage(url: self.curation.mainImage)

                        _ = try? await self.curation.descriptions.concurrentMap { description in
                            try self.curationManager.deleteImage(url: description.image ?? "")
                        }

                        try? await self.curationManager.delete(self.curation.id)

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
        } else {
            showReportController(self, style: .actionSheet, title: "게시글 신고")
        }
    }
}

extension CurationViewController: UITextFieldDelegate { }
