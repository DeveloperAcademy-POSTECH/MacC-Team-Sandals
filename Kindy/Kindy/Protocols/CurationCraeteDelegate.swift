//
//  CurationCraeteDelegate.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/22.
//

import Foundation


protocol CurationCreateDelegate: AnyObject {
    func textFieldEndEditing()
    func openImagePickerForMainImage()
    func selectCategory()
    func deleteItem(index: Int)
    func setupMainTitle(string: String)
    func setupSubTitle(string: String)
    func addDescriptionButtonAction()
}
