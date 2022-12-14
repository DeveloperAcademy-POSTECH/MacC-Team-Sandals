//
//  UIViewController+.swift
//  Kindy
//
//  Created by rbwo on 2022/10/18.
//
import UIKit
import MessageUI

extension UIViewController {
    func gradientView(bounds: CGRect, colors: [CGColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return gradientLayer
    }
    
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        self.view.window?.endEditing(true)
    }
    
    func presentLogInAlert() {
        let alertForLogIn = UIAlertController(
            title: "로그인이 필요한 기능입니다",
            message: "로그인하시겠습니까?",
            preferredStyle: .alert)
        let actionToLogIn = UIAlertAction(
            title: "로그인",
            style: .default,
            handler: { _ in
                let signInViewController = SignInViewController()
                self.navigationController?.pushViewController(signInViewController, animated: true)
            })
        let actionToCancel = UIAlertAction(
            title: "취소",
            style: .cancel)
        
        alertForLogIn.addAction(actionToCancel)
        alertForLogIn.addAction(actionToLogIn)
        
        present(alertForLogIn, animated: true, completion: nil)
    }
}

extension UIViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        showMailAlert(result: result)
    }
    
    private func showMailAlert(result: MFMailComposeResult) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        switch result {
        case .sent:
            sheet.title = "제보 성공"
            sheet.message = "메일이 성공적으로 전송되었습니다."
        case .failed:
            sheet.title = "메일 전송 실패"
            sheet.message = "인터넷 환경 또는 기기 메일 설정을 확인해주세요."
        case .saved:
            sheet.title = "메일 저장"
            sheet.message = "제보 메일이 저장되었습니다."
        case .cancelled:
            sheet.title = "제보 취소"
            sheet.message = "독립서점 제보하기를 취소했습니다."
        @unknown default:
            fatalError()
        }
        
        sheet.addAction(UIAlertAction(title: "확인", style: .cancel))
        present(sheet, animated: true)
    }
}

extension UIViewController {
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}

// MARK: - 서치바

extension UIViewController {
    func setupCustomCancelButton(of searchController: UISearchController) {
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .black
        searchController.searchBar.placeholder = "서점 이름, 주소 검색"
        searchController.searchBar.setShowsCancelButton(true, animated: true)
    }
}
