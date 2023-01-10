//
//  CurationCreateViewController+Delegates.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/12/04.
//

import UIKit
import PhotosUI

// MARK: descriptionTableView Delegate
extension CurationCreateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptionImages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurationCreateDescriptionTableViewCell.identifier, for: indexPath) as? CurationCreateDescriptionTableViewCell else { return UITableViewCell() }
        if let content = curation.descriptions[indexPath.row].content {
            cell.setupData(content, descriptionImages[indexPath.row], index: indexPath.row, textViewDelegate: self, delegate: self)
        } else {
            cell.setupData("", descriptionImages[indexPath.row], index: indexPath.row, textViewDelegate: self, delegate: self)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

// MARK: TextViewDelegate -> 각 TextView 값의 변화에 따라 placeholder 및 curation 변수에 값 할당
extension CurationCreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        needToScroll = true
        if textView.tag == 99 {
            if let text = textView.text, text == headTextViewPlaceHolder && textView.textColor == UIColor.kindyGray {
                textView.text = nil
                textView.textColor = .black

            }
            self.offset = headTextView.frame.minY + headTextView.frame.size.height
        } else {
            if let text = textView.text, text == descriptionTextViewPlaceHolder && textView.textColor == UIColor.kindyGray {
                textView.text = nil
                textView.textColor = .black
            }
            self.offset = descriptionTableView.frame.minY + CGFloat((textView.tag + 1) * 116)
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView.tag {
        case 99:
            curation.headText = textView.text!
        default:
            curation.descriptions[textView.tag].content = textView.text!
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if textView.tag == 99 {
                textView.text = headTextViewPlaceHolder
            } else {
                textView.text = descriptionTextViewPlaceHolder
            }
            textView.textColor = UIColor.kindyGray
        } else {
            switch textView.tag {
            case 99:
                curation.headText = textView.text!
            default:
                curation.descriptions[textView.tag].content = textView.text!
            }
        }
        needToScroll = false
        self.keyboardHeight = 0
    }
}

extension CurationCreateViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let itemProvider = results.first?.itemProvider

        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, _) in
                guard let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    switch self.imagePickerOpenSource {
                    case "descriptionAdd":
                        self.curation.descriptions.append(Description(image: "", content: ""))
                        self.descriptionImages.append(image)
                        self.imagePickerOpenSource = ""
                    case "mainImage":
                        self.mainImage = image
                        self.titleView.setupImage(image)
                        self.imagePickerOpenSource = ""
                        if !self.isMainImageChanged {
                            self.isMainImageChanged = true
                            if !self.curation.mainImage.isEmpty {
                                self.deleteImageURL.append(self.curation.mainImage)
                            }
                        }
                    default:
                        return
                    }
                }
            }
        } else {
            print("phpicker Error")
        }
    }

    // 사진 권한
    func photoAuth(completion: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
            switch status {
            case .authorized:
                completion()
            case .limited:
                completion()
            default:
                let alertController = UIAlertController(
                    title: "해당 기능을 사용하려면 사진 접근 권한이 필요합니다",
                    message: "앱 설정에서 권한을 수정할 수 있습니다.",
                    preferredStyle: .alert
                )
                let cancelAlert = UIAlertAction(
                    title: "닫기",
                    style: .cancel
                ) { _ in
                    alertController.dismiss(animated: true, completion: nil)
                }
                let goToSettingAlert = UIAlertAction(
                    title: "설정하기",
                    style: .default) { _ in
                        guard
                            let settingURL = URL(string: UIApplication.openSettingsURLString),
                            UIApplication.shared.canOpenURL(settingURL)
                        else { return }
                        UIApplication.shared.open(settingURL, options: [:])
                    }
                [cancelAlert, goToSettingAlert].forEach(alertController.addAction(_:))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
                break
            }
        }
    }
}

extension CurationCreateViewController: CurationCreateDelegate {

    /// 키보드 높이를 0으로 만들어 줌
    func textFieldEndEditing() {
        self.keyboardHeight = 0
    }

    func openImagePickerForMainImage() {
        photoAuth {
            self.imagePickerOpenSource = "mainImage"
            self.presentPHPicker()
        }
    }

    func selectCategory() {
        let actionSheet = UIAlertController(title: "*게시글의 카테고리를 선택해 주세요", message: nil, preferredStyle: .actionSheet)
        let bookstore = UIAlertAction(title: "서점", style: .default, handler: { _ in
            self.curation.category = "bookstore"
            self.headTextView.setupCategory("서점")
        })
        let book = UIAlertAction(title: "도서", style: .default, handler: { _ in
            self.curation.category = "book"
            self.headTextView.setupCategory("도서")
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(bookstore)
        actionSheet.addAction(book)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil )
    }

    func deleteItem(index: Int) {
        descriptionImages.remove(at: index)
        let deleteDescription = curation.descriptions.remove(at: index)
        if index < addIndex {
            addIndex -= 1
            deleteImageURL.append(deleteDescription.image ?? "")
        }
    }

    func setupMainTitle(string: String) {
        self.curation.title = string
    }

    func setupSubTitle(string: String) {
        self.curation.subTitle = string
    }

    func addDescriptionButtonAction() {
        if descriptionImages.count < 10 {
            photoAuth {
                self.imagePickerOpenSource = "descriptionAdd"
                //                self.presentAlbum()
                self.presentPHPicker()
            }
        }
    }
}
