//
//  CurationViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

final class CurationViewController: UIViewController {

    let replyDummy = [["니버", "좋네요 너무 가보고 싶어요 ! 좋네요 가보고 싶어요 ! 좋네요 너무 가보고 싶어요 ! 좋네요 너무 가보고 싶어요 ! 좋네요 너무 가보고 싶어요 ! 좋네요 너무 가보고 싶어요 !", "2022-11-04 •"], ["니버", "어쩌라구용~", "2022-11-04 •"], ["니버", "좋네요 너무 가보고 싶어요  좋네요 너무 가보고 싶어요  좋네요 너무 가보고 싶어요 !", "2022-11-04 •"], ["니버", "별룬데요 !", "2022-11-04 • "], ["니버", " 굿! ", "2022-11-04 • "]]

    private var curation: Curation

    private var cellCount: Int = 0
    private var replyCount: Int = 0

    private var bookstoresRequestTask: Task<Void, Never>?
    private let firestoreManager = FirestoreManager()
    private let images: [UIImage]

    private var bookStore: Bookstore?

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
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bookstoresRequestTask = Task {
            self.bookStore = try? await firestoreManager.fetchBookstore(with: curation.bookstoreID)
            bookstoresRequestTask = nil
        }
    }

    private lazy var bottomView: UIView = {
        let view = CurationButtonStackView(frame: .zero, curation: curation)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        createLayout()
    }
}

private extension CurationViewController {
    func configureCollectionView() {
        collectionView.register(CurationStoreCell.self, forCellWithReuseIdentifier: CurationStoreCell.identifier)

        collectionView.register(CurationTextCell.self, forCellWithReuseIdentifier: CurationTextCell.identifier)

        collectionView.register(CurationDetailCell.self, forCellWithReuseIdentifier: CurationDetailCell.identifier)

        collectionView.register(CurationReplyCell.self, forCellWithReuseIdentifier: CurationReplyCell.identifier)
    }

    func createLayout() {
        view.addSubview(collectionView)
        view.addSubview(bottomView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -72),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),

            bottomView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension CurationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationStoreCell.identifier, for: indexPath) as? CurationStoreCell else {
                return UICollectionViewCell() }
            cell.configure(image: images[0], bookStore: curation.bookstoreID)
            cell.backgroundColor = .clear
            return cell
        }
        else if indexPath.item == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationTextCell.identifier, for: indexPath) as? CurationTextCell else { return UICollectionViewCell() }
            cell.headConfigure(data: curation)
            return cell
        } else if indexPath.item > cellCount {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationReplyCell.identifier, for: indexPath) as? CurationReplyCell else { return UICollectionViewCell() }
            cell.configure(data: replyDummy[replyCount - indexPath.row])
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationDetailCell.identifier, for: indexPath) as? CurationDetailCell else { return UICollectionViewCell() }

        cell.configure(description: curation.descriptions[indexPath.item - 2], image: images[indexPath.item - 1])
        return cell
    }
}
extension CurationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellCount += 1
        cellCount += curation.descriptions.count
        return cellCount + 1
        // TODO: replyDummy 를 큐레이션 모델 내부에 reply를 받아와서 count 하는 코드로 변경
//        replyCount = cellCount + replyDummy.count
//        return replyCount + 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let bookstoreVC = DetailBookstoreViewController()
            bookstoreVC.bookstore = bookStore
            let naviVC = UINavigationController(rootViewController: bookstoreVC)
            naviVC.modalPresentationStyle = .overFullScreen
            show(naviVC, sender: nil)
        }
    }
}

extension CurationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}
