//
//  CurationViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

final class CurationViewController: UIViewController {
    
    weak var cellDelegate: DynamicCell?
    
    private var curation: Curation
    
    private var cellCount = 0
    
    private var cellHeight: CGFloat = 0

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
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
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
    }
    
    func createLayout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
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
            cell.layer.zPosition = 1
            return cell
        }

        else if indexPath.item == 1 || indexPath.item == cellCount{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationTextCell.identifier, for: indexPath) as? CurationTextCell else { return UICollectionViewCell() }
            if indexPath.item == cellCount {
                cell.alpha = 0
            }
            cell.headConfigure(data: curation)
            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationDetailCell.identifier, for: indexPath) as? CurationDetailCell else { return UICollectionViewCell() }

        cell.configure(description: curation.descriptions[indexPath.item - 2], image: images[indexPath.item - 1])
        return cell
    }
}
extension CurationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellCount += 2
        cellCount += curation.descriptions.count
        return cellCount + 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let vc = DetailBookstoreViewController()
            vc.bookstore = bookStore
            show(vc, sender: nil)
        }
    }
}

extension CurationViewController: UICollectionViewDelegateFlowLayout {
    /// 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width: CGFloat = UIScreen.main.bounds.width
        let height: CGFloat = UIScreen.main.bounds.height
    
        if indexPath.item == 0 {
            return CGSize(width: width, height: height / 7)
        } else if indexPath.item == 1 || indexPath.item == cellCount {
            let height: Double = Double(curation.headText.count) / 27.2 * 20
            return CGSize(width: width, height: height + 100)
        }
        else {
            let height: Double = Double(curation.descriptions[indexPath.row - 2].content!.count) / 27.2 * 20
            // image height를 고정한다면 밑에 더해주면 댐다
            return CGSize(width: width, height: height + 400)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}
