//
//  BottomSheetViewController.swift
//  Kindy
//
//  Created by rbwo on 2022/10/23.
//

import UIKit

final class BottomSheetViewController: UIViewController {
    
    enum BottomSheetViewState {
        case expanded
        case normal
    }
    
    weak var delegate: ChangeLayout?
    weak var popDelegate: PopView?
    
    private let contentViewController: UIViewController
    
    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dismissButton: UIButton = {
        let view = UIButton()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 26)
        let image = UIImage(systemName: "multiply.circle.fill", withConfiguration: imageConfig)
        
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomSheetPanMinTopConstant: CGFloat = dismissButton.frame.height + 66.5
    
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant
    
    private lazy var defaultHeight: CGFloat = screenHeight * 0.52
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        // TODO: 모달로 애니메이션을 준다면 cornerRadius 넣고 아니면 빼기
        //view.layer.cornerRadius = 30
        //view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(presentReport(_:)), name: .Report, object: nil)
        setupLayout()
        configureGesture()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: false)
        self.popDelegate?.dismissHeaderView()
        
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func configureGesture() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
    }
    
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: view)
        
        switch panGestureRecognizer.state {
        case .began:
            bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
        case .changed:
            // 바텀 시트가 위에 고정 되어 있을때 드래그를 위로해도 아무런 일이 일어나지 않게 하는 코드
            if bottomSheetPanStartingTopConstant == bottomSheetPanMinTopConstant && bottomSheetPanStartingTopConstant + translation.y > screenHeight * 0.65 { }
            // 바텀 시트 화면을 일정거리이상 밑으로 드래그 하는것을 방지
            else if bottomSheetPanStartingTopConstant + translation.y > screenHeight * 0.65 && bottomSheetViewTopConstraint.constant != bottomSheetPanMinTopConstant {
                bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant
                
                self.dismiss(animated: false)
                popDelegate?.dismissHeaderView()
                
                delegate?.defaultHeaderLayout()
                showBottomSheet(atState: .normal)
            }
            // 사용자의 드래그 위치에 맞게 오토레이아웃 변경
            else if bottomSheetPanStartingTopConstant + translation.y > bottomSheetPanMinTopConstant {
                bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
                delegate?.changeLayout(y: translation.y)
            }
            
        case .ended:
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding = view.safeAreaInsets.bottom
            let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight
            
            let standardHeight = screenHeight * 0.3
            
            let nearestValue = nearest(to: bottomSheetViewTopConstraint.constant, inValues: [bottomSheetPanMinTopConstant, standardHeight, defaultPadding, safeAreaHeight + bottomPadding])
            
            if nearestValue == bottomSheetPanMinTopConstant || (translation.y < 0 && nearestValue == standardHeight) {
                showBottomSheet(atState: .expanded)
                delegate?.setTopHeaderLayout()
            } else if translation.y > 0 && nearestValue == standardHeight {
                showBottomSheet(atState: .normal)
                delegate?.defaultHeaderLayout()
            } else if nearestValue == defaultPadding {
                showBottomSheet(atState: .normal)
                delegate?.defaultHeaderLayout()
            } else {
                showBottomSheet(atState: .normal)
                delegate?.defaultHeaderLayout()
            }
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    private func showBottomSheet(atState: BottomSheetViewState = .normal) {
        guard let vc = self.contentViewController as? CurationViewController else { return }

        if atState == .normal {
            vc.view.isUserInteractionEnabled = false
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        } else {
            vc.view.isUserInteractionEnabled = true
            // 확장시 위치
            bottomSheetViewTopConstraint.constant = bottomSheetPanMinTopConstant
            
        }
        
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setupLayout() {
        view.addSubview(dismissButton)
        view.addSubview(bottomSheetView)
        bottomSheetView.addSubview(contentViewController.view)
        
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        
        let buttonConstant = screenHeight * 0.05
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: buttonConstant),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetViewTopConstraint,
            
            contentViewController.view.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 30),
            contentViewController.view.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            contentViewController.view.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor)
        ])
    }
    
    private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }
}

extension BottomSheetViewController: Reportable {
    @objc private func presentReport(_ notification: Notification) {
        showReportController(self, style: .actionSheet)
    }
}

