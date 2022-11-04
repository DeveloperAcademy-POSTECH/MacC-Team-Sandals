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

class PagingCurationViewController: UIViewController {
    
    private var curation: Curation

    init(curation: Curation) {
        self.curation = curation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var headerViewHeightConstant: CGFloat!
    private var headerViewDefaultHeightConstant: CGFloat!
    
    private var headerViewHeightConstraint: NSLayoutConstraint!
    
    private lazy var headerView: UIView = {
        let view = CurationHeaderView(frame: .zero, curation: curation)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
        navigationController?.navigationBar.isHidden = true
    }
    
    // 뷰 합치면 여기서 띄울건데 이상하면 viewDidAppear에서 ~
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        dimmingView.alpha = 1
    //
    //        let bottomVC = BottomSheetViewController(contentViewController: CurationViewController())
    //        bottomVC.modalPresentationStyle = .overFullScreen
    //        present(bottomVC, animated: false)
    //        bottomVC.view.alpha = 0
    //
    //        // 같이 보여주고 싶어서 잠시 시간을 줬슴니당
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    //            UIView.transition(with: self.view, duration: 0, options: .curveEaseIn) {
    //                bottomVC.view.alpha = 1
    //                self.dimmingView.alpha = 0
    //                bottomVC.delegate = self
    //            }
    //        }
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
        
        createGradient(view: headerView, startAlpha: 0.6)
        changeGradientLayer(view: headerView)
        
        dimmingView.alpha = 1
        
        let bottomVC = BottomSheetViewController(contentViewController: CurationViewController(curation: curation))
        bottomVC.modalPresentationStyle = .overFullScreen
        bottomVC.delegate = self
        bottomVC.popDelegate = self
        bottomVC.view.alpha = 0
        
        // 뷰를 같이 띄우고 싶어서 잠시 시간을 줬슴니당
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.27) {
            UIView.transition(with: self.view, duration: 0.3, options: .curveEaseIn) {
                self.present(bottomVC, animated: false)
                bottomVC.view.alpha = 1
                self.dimmingView.alpha = 0
            }
        }
    }
    
    private func configureUI() {
        view.addSubview(headerView)
        view.addSubview(dimmingView)
        
        headerViewHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: screenHeight * 0.65)
        headerViewHeightConstant = headerViewHeightConstraint.constant
        headerViewDefaultHeightConstant = headerViewHeightConstraint.constant
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerViewHeightConstraint,
            
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func createGradient(view: UIView, startAlpha: CGFloat, at: UInt32 = 1) {
        let gradientSize = CGRect(x: 0, y: 0 , width: view.bounds.width , height: view.bounds.height)
        let gradient = gradientView(bounds: gradientSize ,colors: [UIColor(red: 0, green: 0, blue: 0, alpha: startAlpha).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor])
        
        view.layer.insertSublayer(gradient, at: at)
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
