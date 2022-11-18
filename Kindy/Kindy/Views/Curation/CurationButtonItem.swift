//
//  CurationButtonItemView.swift
//  Kindy
//
//  Created by rbwo on 2022/11/09.
//

import UIKit

final class CurationButtonItemView: UIView {

    enum Views {
        case heart
        case reply
    }

    private var isLoggedIn: Bool = false
    private var userID: String = ""

    private var userRequestTask: Task<Void, Never>?
    private var likeUpdateTask: Task<Void, Never>?
    private let firestoreManager = FirestoreManager()

    private var view: Views
    private var user: User?

    private var curation: Curation
    private let buttonImage: String

    private lazy var heartCount: Int = curation.likes.count
//    private lazy var replyCount: Int = curation.replys.count

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var buttonView: UIButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: buttonImage, withConfiguration: imageConfig)

        view.setImage(image, for: .normal)
        view.tintColor = .kindySecondaryGreen

        view.addTarget(self, action: #selector(customAction), for: .touchUpInside)
        return view
    }()

    private let countLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .headline
        view.textColor = .black
        return view
    }()

    init(frame: CGRect, curation: Curation, viewName: Views) {
        self.curation = curation
        switch viewName {
        case .heart:
            self.view = .heart
            self.buttonImage = "heart"
            print(curation.likes.count)
            self.countLabel.text = String(curation.likes.count)
        case .reply:
            self.view = .reply
            self.buttonImage = "bubble.left"
            self.countLabel.text = String(curation.likes.count)
        }
        super.init(frame: frame)
        setupUI()
        checkLiked()

        NotificationCenter.default.addObserver(self, selector: #selector(setupUser(_:)), name: .LoggedIn, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(buttonView)
        stackView.addArrangedSubview(countLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    private func checkLiked() {
        if isLoggedIn || firestoreManager.isLoggedIn() {
            isLoggedIn = true
            userRequestTask = Task {
                userRequestTask?.cancel()
                if userID == "" {
                    self.userID = firestoreManager.getUserID()
                }

                if curation.likes.contains(userID) {
                    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
                    let image = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
                    buttonView.setImage(image, for: .normal)
                }
                userRequestTask = nil
            }
        }
    }

    @objc private func setupUser(_ notification: Notification) {
        checkLiked()
    }
}

private extension CurationButtonItemView {
    @objc func customAction() {
        if isLoggedIn || firestoreManager.isLoggedIn() {
            switch view {
            case .heart:
                likeUpdateTask = Task {
                    likeUpdateTask?.cancel()
                    if curation.likes.contains(userID) {
                        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
                        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
                        buttonView.setImage(image, for: .normal)

                        curation.likes = curation.likes.filter { $0 != userID }
                        self.countLabel.text = String(curation.likes.count)
                        try? await firestoreManager.updateLike(bookstoreID: curation.bookstoreID, likes: curation.likes)
                    } else {
                        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
                        let image = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
                        buttonView.setImage(image, for: .normal)

                        curation.likes.append(userID)
                        self.countLabel.text = String(curation.likes.count)
                        try? await firestoreManager.updateLike(bookstoreID: curation.bookstoreID, likes: curation.likes)
                    }
                    likeUpdateTask = nil
                }
            case .reply:
                print("reply")
            }
        } else {
            NotificationCenter.default.post(name: .Loggin, object: nil)
        }
    }
}
