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
    
    init(curation: Curation) {
        self.curation = curation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = CurationButtonStackView(frame: .zero)
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

// 데이터 들어오면 configure 바꿔야함
extension CurationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationStoreCell.identifier, for: indexPath) as? CurationStoreCell else {
                return UICollectionViewCell() }
            cell.configure(curation: curation)
            cell.backgroundColor = .clear
            cell.layer.zPosition = 1
            return cell
        }
        
        else if indexPath.item == 1 || indexPath.item == cellCount {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationTextCell.identifier, for: indexPath) as? CurationTextCell else { return UICollectionViewCell() }
            
            if indexPath.item == 1 {
                cell.headConfigure(data: curation)
            }
            else {
                cell.infoConfigure(data: curation)
            }
            return cell
        } else if indexPath.item > cellCount {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationReplyCell.identifier, for: indexPath) as? CurationReplyCell else { return UICollectionViewCell() }
            cell.configure(data: replyDummy[replyCount - indexPath.row])
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationDetailCell.identifier, for: indexPath) as? CurationDetailCell else { return UICollectionViewCell() }
        
        cell.configure(imageWithText: curation.imageWithText[indexPath.item - 2])
        return cell
    }
}
extension CurationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellCount += 2
        cellCount += curation.imageWithText.count
        // TODO: replyDummy 를 큐레이션 모델 내부에 reply를 받아와서 count 하는 코드로 변경
        replyCount = cellCount + replyDummy.count
        return replyCount + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let vc = DetailBookstoreViewController()
            vc.bookstore = curation.bookStore
            show(vc, sender: nil)
            // present(vc, animated: false)
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
