//
//  CheckPolicyDelegate.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/09.
//

import Foundation

protocol CheckPolicyDelegate: AnyObject {
    func policySheetOpen(_ title: String)
    func isTotalToogle()
    func isFirstToggle()
    func isSecondToggle()
}
