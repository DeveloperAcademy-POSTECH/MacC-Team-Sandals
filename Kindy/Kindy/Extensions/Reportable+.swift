//
//  Reportable+.swift
//  Kindy
//
//  Created by rbwo on 2022/11/10.
//

import UIKit

extension Reportable {
    private var reportList: [String] {
        return ["스팸 및 도배", "거짓, 불법 정보", "개인 정보 침해", "욕설, 비방, 차별, 혐오", "성인용 컨텐츠",]
    }
    /// 아래 함수를 변수에 클로저를 담아서 구현을 하는게 나은지 그냥 아래가 나은지.. ?
    /// 아니면 다른 방법? 취소 액션이 중복인데 이를 따로 함수로 만들어야 할지? 고작 두번이긴한데 ,, 잘 판단이 안섭니다 ㅜㅜㅜ
    func showReportController(_ self: UIViewController, style: UIAlertController.Style, title: String = "댓글 신고") {
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

    func showReportController2(_ self: UIViewController, style: UIAlertController.Style, title: String = "댓글 신고") {
        let completeHandler: (UIAlertAction) -> Void = { report in
            let alertController = UIAlertController(title: "신고해주셔서 감사합니다", message: "더 나은 서비스 제공을 위해\n 빠른 시일 내로 확인하여 반영하겠습니다", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "완료", style: .default)

            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }

        let reportReasonHandler: (UIAlertAction) -> Void = { _ in
            let alertController = UIAlertController(title: "", message: "신고 사유를 선택해 주세요", preferredStyle: .actionSheet)
            reportList.forEach { text in
                let okAction = UIAlertAction(title: text, style: .default) { action in
                    completeHandler(action)
                }
                alertController.addAction(okAction)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)

        let okAction = UIAlertAction(title: title, style: .destructive) { action in
            reportReasonHandler(action)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true)
    }

}
