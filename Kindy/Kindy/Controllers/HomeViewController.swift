//
//  ViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/17.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: Section
    enum Section: Hashable {
        case mainCuration
        case curations
        case nearByBookstore
        case bookmarked
        case region
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

