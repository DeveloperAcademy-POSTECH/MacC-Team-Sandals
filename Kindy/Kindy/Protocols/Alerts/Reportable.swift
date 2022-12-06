//
//  Reportable.swift
//  Kindy
//
//  Created by rbwo on 2022/11/10.
//

import UIKit

protocol Reportable {
    func showReportController(_ self: UIViewController, style: UIAlertController.Style, title: String)
}

extension Reportable {
    private var reportList: [String] {
        return ["스팸 및 도배", "거짓, 불법 정보", "개인 정보 침해", "욕설, 비방, 차별, 혐오", "성인용 컨텐츠",]
    }

    func showReportController(_ self: UIViewController, style: UIAlertController.Style, title: String = "댓글 신고") {
        self.hideKeyboard()
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)

        let okAction = UIAlertAction(title: title, style: .destructive) { _ in
            let alertController = UIAlertController(title: "", message: "신고 사유를 선택해 주세요", preferredStyle: .actionSheet)
            reportList.forEach { text in
                let okAction = UIAlertAction(title: text, style: .default) { report in
                    let alertController = UIAlertController(title: "신고가 접수되었습니다", message: "더 나은 서비스 제공을 위해\n 빠른 시일 내로 확인하여 처리하겠습니다.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "완료", style: .default)

                    alertController.addAction(okAction)
                    self.present(alertController, animated: true)
                }
                alertController.addAction(okAction)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }

        alertController.addAction(okAction)

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
    }
}
