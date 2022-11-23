//
//  CurationButtonItemView.swift
//  Kindy
//
//  Created by rbwo on 2022/11/09.
//
import UIKit

protocol ReplyButtonAction: AnyObject {
    func showingKeyboard()
}

final class CurationButtonItemView: UIView {

    enum Views {
        case heart
        case reply
    }

    weak var delegate: ReplyButtonAction?

    private var isLoggedIn: Bool = false
    private var userID: String = ""

    private var userRequestTask: Task<Void, Never>?
    private var likeUpdateTask: Task<Void, Never>?

    private var view: Views
    private var user: User?

    private var curation: Curation
    private let buttonImage: String

    private lazy var heartCount: Int = curation.likes.count
    private var commentCount: Int {
        get {
            if let count = curation.comments?.count {
                return count
            } else {
                return 0
            }
        }
    }

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

    let countLabel: UILabel = {
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
            self.countLabel.text = String(curation.likes.count)
            super.init(frame: frame)
        case .reply:
            self.view = .reply
            self.buttonImage = "bubble.left"
            super.init(frame: frame)
            self.countLabel.text = String(commentCount)
        }
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
        if isLoggedIn || UserManager().isLoggedIn() {
            isLoggedIn = true
            userRequestTask = Task {
                userRequestTask?.cancel()
                if userID == "" {
                    self.userID = UserManager().getID()
                }

                    if curation.likes.contains(userID) {
                        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
                        let image = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
                        buttonView.setImage(image, for: .normal)
                    }
                    userRequestTask = nil
                }
            }
        case .reply:
            return
        }
    }

    @objc private func setupUser(_ notification: Notification) {
        checkLiked()
    }
}

private extension CurationButtonItemView {
    @objc func customAction() {
        if isLoggedIn || UserManager().isLoggedIn() {
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
                        try? await CurationRequest().updateLike(bookstoreID: curation.bookstoreID, likes: curation.likes)
                    } else {
                        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
                        let image = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
                        buttonView.setImage(image, for: .normal)

                        curation.likes.append(userID)
                        self.countLabel.text = String(curation.likes.count)
                        try? await CurationRequest().updateLike(bookstoreID: curation.bookstoreID, likes: curation.likes)
                    }
                    likeUpdateTask = nil
                }
            case .reply:
                delegate?.showingKeyboard()
            }
        } else {
            NotificationCenter.default.post(name: .Loggin, object: nil)
        }
    }
}
