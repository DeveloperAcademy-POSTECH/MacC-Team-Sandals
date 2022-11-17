//
//  SignUpDelegate.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/09.
//

import Foundation


protocol SignUpDelegate: AnyObject {
    func isToggle(_ totalCheck: Bool)
    func policySheetOpen(_ title: String)
    func signUpDelegate()
    func textFieldAction(_ nickname: String)
}
