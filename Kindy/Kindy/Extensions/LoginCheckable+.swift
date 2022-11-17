//
//  LoginCheckable.swift
//  Kindy
//
//  Created by rbwo on 2022/11/17.
//

import UIKit

extension LoginCheckable {
    func showLoginController(_ self: UIViewController) {
        let alertForSignIn = UIAlertController(title: "로그인이 필요한 기능입니다", message: "로그인하시겠습니까?", preferredStyle: .alert)
        let action = UIAlertAction(title: "네", style: .default, handler: { _ in
            let signinVC = SignInViewController()
            self.present(signinVC, animated: true)
        })
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        alertForSignIn.addAction(cancel)
        alertForSignIn.addAction(action)
        self.present(alertForSignIn, animated: true, completion: nil)
    }
}
