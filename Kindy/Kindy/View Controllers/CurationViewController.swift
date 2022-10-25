//
//  CurationViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

final class CurationViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: CurationLayout.init())
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
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
        
        collectionView.register(CurationHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CurationHeaderView.identifier)
        
        collectionView.register(TestCurationCell.self, forCellWithReuseIdentifier: TestCurationCell.identifier)

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
    /// 헤더 셀, 서점 정보셀 큐레이션 내용셀로 나누었습니다.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CurationHeaderView.identifier, for: indexPath)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCurationCell.identifier, for: indexPath) as? TestCurationCell else {
                return UICollectionViewCell() }
            cell.configure()
            cell.backgroundColor = .clear
            cell.layer.zPosition = 1
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationDetailCell.identifier, for: indexPath) as? CurationDetailCell else { return UICollectionViewCell() }
        cell.backgroundColor = .white
        cell.configure()
        cell.layer.zPosition = 1
        return cell
    }
}
extension CurationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}

extension CurationViewController: UICollectionViewDelegateFlowLayout {
    /// 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = self.view.frame.width
        let height: CGFloat = self.view.frame.height

        if indexPath.item == 0 {
            return CGSize(width: width, height: height / 5)
        } else {
            guard let collectionViewLayout = collectionViewLayout as? CurationLayout else { return CGSize() }
            collectionViewLayout.headerReferenceSize = CGSize(width: width, height: height * 0.44)
            collectionViewLayout.estimatedItemSize = CGSize(width: width, height: 950)
            return collectionViewLayout.estimatedItemSize
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}
