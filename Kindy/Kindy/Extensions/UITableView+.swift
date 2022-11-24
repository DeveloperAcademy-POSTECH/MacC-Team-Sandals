//
//  UITableView+.swift
//  Kindy
//
//  Created by Park Kangwook on 2022/10/21.
//

import UIKit
import MessageUI

extension UITableView: MFMailComposeViewControllerDelegate{
    func setEmptyView(text message: String) {
        let emptyView = EmptyView()
        emptyView.emptyViewMessage = message
        emptyView.reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)

        self.backgroundView = emptyView
    }
    
    func setCurationEmptyView(text message: String) {
        let emptyView = EmptyView()
        emptyView.emptyViewMessage = message
        emptyView.reportButton.isHidden = true
        
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    @objc func reportButtonTapped() {
        let viewController = self.findViewController()
        let recipientEmail = "teamsandalsofficial@gmail.com"
        let subject = "[독립서점 제보] 제목을 입력해주세요"
        let body = "제보하려는 독립서점의 이름, 사진, 주소를 남겨주시면, 킨디에서 확인하고 업로드 할게요 :)"
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = viewController
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            viewController?.present(mail, animated: true)
            
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    @objc func feedbackButtonTapped() {
        let viewController = self.findViewController()
        let recipientEmail = "teamsandalsofficial@gmail.com"
        let subject = "[의견 보내기] 제목을 입력해주세요"
        let body = "킨디에게 남기고 싶은 의견을 자유롭게 작성해주세요 :)"
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = viewController
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            viewController?.present(mail, animated: true)
            
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        }
        
        return defaultUrl
    }
}
