//
//  CurationViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//

import UIKit

final class CurationViewController: UIViewController {
    
    weak var cellDelegate: DynamicCell?
    
    private var curationModel: Curation?
    
    private var curation = Curation.item
    
    private var cellCount = 0
    
    private var cellHeight: CGFloat = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(curationModel: Curation) {
        self.curation = curationModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        
//        let width: CGFloat = UIScreen.main.bounds.width
//        let height: CGFloat = UIScreen.main.bounds.height
//        let flowlayout = UICollectionViewFlowLayout()
//
//        flowlayout.estimatedItemSize = CGSize(width: width, height: height)
//        view.collectionViewLayout = flowlayout
        
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

// 데이터 들어오면 configure 바꿔야함
extension CurationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationStoreCell.identifier, for: indexPath) as? CurationStoreCell else {
                return UICollectionViewCell() }
            cell.configure()
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
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurationDetailCell.identifier, for: indexPath) as? CurationDetailCell else { return UICollectionViewCell() }
        
        // 수정 필요 동적으로 높이를 잡아줘야하는데 ~~
        cell.configure(imageWithText: curation.imageWithText[indexPath.item - 2])

        cellHeight = cell.cellHeight
        print(cellHeight)
        
        return cell
    }
}
extension CurationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellCount += 2
        cellCount += curation.imageWithText.count
        return cellCount + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            
            // TODO: present 서점 정보
            let vc = DetailBookstoreViewController()
            // 뷰 합치면 넣어야함
            // vc.bookstore = Bookstore
            show(vc, sender: nil)
             
            // present(vc, animated: false)
        }
    }
}

extension CurationViewController: UICollectionViewDelegateFlowLayout {
    /// 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width: CGFloat = UIScreen.main.bounds.width
        let height: CGFloat = UIScreen.main.bounds.height

        if indexPath.item == 0 {
            return CGSize(width: width, height: height / 5)
        } else if indexPath.item == 1 || indexPath.item == cellCount {
            return CGSize(width: width, height: 200)
        }
        else {
            return CGSize(width: width, height: 600)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}
