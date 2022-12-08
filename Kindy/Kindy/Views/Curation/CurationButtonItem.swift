//
//  CurationButtonItemView.swift
//  Kindy
//
//  Created by rbwo on 2022/11/09.
//
import UIKit

protocol CommentButtonAction: AnyObject {
    func showingKeyboard()
}

protocol ShowingMenu: AnyObject {
    func showingMenu()
}

final class CurationButtonItemView: UIView {
    
    enum Views {
        case heart
        case comment
        case setting
    }
    
    weak var delegate: CommentButtonAction?
    weak var menuDelegate: ShowingMenu?
    
    private var isLoggedIn: Bool = false
    private var userID: String = ""
    
    private var userRequestTask: Task<Void, Never>?
    private var likeUpdateTask: Task<Void, Never>?
    
    private var view: Views
    private var user: User?
    
    private var curation: Curation?
    private let buttonImage: String
    
    private lazy var heartCount: Int = curation?.likes.count ?? 0
    private var commentCount: Int {
        get {
            if let count = curation?.commentCount {
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
    
    private(set) lazy var countLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .headline
        view.textColor = .black
        return view
    }()
    
    init(frame: CGRect, curation: Curation? = nil, viewName: Views) {
        self.curation = curation
        switch viewName {
        case .heart:
            self.view = .heart
            self.buttonImage = "heart"
            super.init(frame: frame)
            self.countLabel.text = String(heartCount)
        case .comment:
            self.view = .comment
            self.buttonImage = "bubble.left"
            super.init(frame: frame)
            self.countLabel.text = String(commentCount)
        case .setting:
            self.view = .setting
            self.buttonImage = "ellipsis"
            super.init(frame: frame)
            self.buttonView.transform = .init(rotationAngle: .pi / 2)
            self.buttonView.tintColor = .kindyGray
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
        switch view {
        case .heart:
            stackView.addArrangedSubview(countLabel)
        case .comment:
            stackView.addArrangedSubview(countLabel)
        case .setting:
            break
        }
//        stackView.addArrangedSubview(countLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func checkLiked() {
        switch view {
        case .heart:
            if isLoggedIn || UserManager().isLoggedIn() {
                isLoggedIn = true
                userRequestTask = Task {
                    guard let curation = curation else { return }
                    userRequestTask?.cancel()
                    if userID == "" {
                        self.userID = UserManager().getID()
                    }
//                    if curation?.likes.contains(userID)
                    if curation.likes.contains(userID) {
                        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
                        let image = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
                        buttonView.setImage(image, for: .normal)
                    }
                    userRequestTask = nil
                }
            }
        case .comment:
            return
        case .setting:
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
                    guard var curation = self.curation else { return }
                    if curation.likes.contains(userID) {
                        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
                        let image = UIImage(systemName: "heart", withConfiguration: imageConfig)
                        buttonView.setImage(image, for: .normal)
                        
                        curation.likes = curation.likes.filter { $0 != userID }
                        self.countLabel.text = String(curation.likes.count)
                        try? await CurationRequest().updateLike(curationID: curation.id, likes: curation.likes)
                    } else {
                        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
                        let image = UIImage(systemName: "heart.fill", withConfiguration: imageConfig)
                        buttonView.setImage(image, for: .normal)
                        
                        curation.likes.append(userID)
                        self.countLabel.text = String(curation.likes.count)
                        try? await CurationRequest().updateLike(curationID: curation.id, likes: curation.likes)
                    }
                    self.curation = curation
                    likeUpdateTask = nil
                }
            case .comment:
                delegate?.showingKeyboard()
            case .setting:
                menuDelegate?.showingMenu()
            }
        } else {
            NotificationCenter.default.post(name: .Loggin, object: nil)
        }
    }
}

