//
//  SectionHeaderDelegate.swift
//  Kindy
//
//  Created by 정호윤 on 2022/10/20.
//

import Foundation

protocol SectionHeaderDelegate: AnyObject {
    func segueWithSectionIndex(_ sectionIndex: Int)
}
