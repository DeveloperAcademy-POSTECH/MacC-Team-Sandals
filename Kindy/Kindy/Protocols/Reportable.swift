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
