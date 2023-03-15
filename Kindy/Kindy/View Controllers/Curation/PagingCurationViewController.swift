//
//  PagingCurationViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/23.
//

import UIKit

protocol ChangeLayout: AnyObject {
    func defaultHeaderLayout()
    func changeLayout(y: Double)
    func setTopHeaderLayout()
}

protocol PopView: AnyObject {
    func popView()
    func dismissHeaderView()
}

protocol ChangeHeaderView: AnyObject {
    func changeHeaderView(title: String, subtitle: String, image: UIImage)
}

final class PagingCurationViewController: UIViewController {

    private var curation: Curation
    private let mainImage: UIImage?

    private var curationRequestTask: Task<Void, Never>?
    private var imageRequestTask: Task<Void, Never>?

    private var images: [UIImage] = []

    private let activityIndicatorView = ActivityIndicatorView()

    init(curation: Curation, mainImage: UIImage? = nil) {
        self.curation = curation
        self.mainImage = mainImage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var headerViewHeightConstant: CGFloat!
    private var headerViewDefaultHeightConstant: CGFloat!

    private var headerViewHeightConstraint: NSLayoutConstraint!

    private(set) lazy var headerView: CurationHeaderView = {
        let view = CurationHeaderView(frame: .zero, curation: curation)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var bottomVC: UIViewController = {
        let bottomVC = BottomSheetViewController(curation: curation, images: images)
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.delegate = self
        bottomVC.popDelegate = self
        bottomVC.changeHeaderViewDelegate = self
    
        return bottomVC
    }()

    override var prefersStatusBarHidden: Bool { true }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageRequestTask = Task {
            if let mainImage = try? await ImageCache.shared.load(curation.mainImage) {
                headerView.imageView.image = mainImage
                self.images.append(mainImage)
            } else {
                self.images.append(UIImage())
            }
            imageRequestTask = nil
        }
        configureUI()
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.present(bottomVC, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.present(bottomVC, animated: false)
        changeGradientLayer(view: headerView)
    }

    private func configureUI() {
        view.addSubview(headerView)

        headerViewHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: screenHeight * 0.65)
        headerViewHeightConstant = headerViewHeightConstraint.constant
        headerViewDefaultHeightConstant = headerViewHeightConstraint.constant

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerViewHeightConstraint
        ])
    }
    
    private func changeGradientLayer(view: UIView) {
        guard let layers = view.layer.sublayers else { return }
        for layer in layers {
            guard let gradientLayer = layer as? CAGradientLayer else { continue }
            let bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.bounds.height)
            gradientLayer.frame = bounds
        }
    }
}

extension PagingCurationViewController: ChangeLayout {
    func changeLayout(y: Double) {
        headerViewHeightConstraint.constant = headerViewHeightConstant + y

        changeGradientLayer(view: headerView)
    }

    func defaultHeaderLayout() {
        headerViewHeightConstraint.constant = headerViewDefaultHeightConstant
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        headerViewHeightConstant = headerViewDefaultHeightConstant

        changeGradientLayer(view: headerView)
    }

    func setTopHeaderLayout() {
        let defaultHeight: CGFloat = (0.65 * screenHeight + 96.5) - (0.52 * screenHeight)

        headerViewHeightConstant = screenHeight * 0.05 + 30 + defaultHeight
        headerViewHeightConstraint.constant = headerViewHeightConstant
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)

        changeGradientLayer(view: headerView)
    }
}

extension PagingCurationViewController: PopView {
    func popView() {
        self.navigationController?.popViewController(animated: false)
    }

    func dismissHeaderView() {
        self.dismiss(animated: true)
    }
}

extension PagingCurationViewController: ChangeHeaderView {
    func changeHeaderView(title: String, subtitle: String, image: UIImage) {
        headerView.titleLabel.text = title
        headerView.subtitleLabel.text = subtitle
        headerView.imageView.image = image
    }
}
