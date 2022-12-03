//
//  CurationCreateViewController.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/20.
//

import UIKit
import PhotosUI

final class CurationCreateViewController: UIViewController {
    // descriptionTable의 높이를 변화시키기 위한 변수
    private var tableHeight: NSLayoutConstraint?
    
    typealias newImageAndCuration = ([UIImage], Curation) -> Void
    var newImageAndCuration: newImageAndCuration!
    
    private var keyboardHeight: CGFloat = 0 {
        didSet {
            guard let _ = keyboardHeightAnchor else { return }
            NSLayoutConstraint.deactivate([keyboardHeightAnchor!])
            keyboardHeightAnchor = keyboardView.heightAnchor.constraint(equalToConstant: keyboardHeight)
            NSLayoutConstraint.activate([keyboardHeightAnchor!])
            mainScrollView.updateContentSize()
            if needToScroll {
                mainScrollView.scrollToTextView(self.offset, height: view.frame.height, keyboardHeight: keyboardHeight)
            }
        }
    }
    // 키보드뷰의 높이값을 변화시켜주기 위함
    private var keyboardHeightAnchor: NSLayoutConstraint?
    
    private var curation:Curation {
        didSet {
            checkIsEnable()
        }
    }
    private var mainImage:UIImage? {
        didSet {
            checkIsEnable()
        }
    }
    
    // 이미지 갯수가 달라지면 tableView의 높이 변화를 주고, scrollView의 scroll범위 값을 다시 설정해준다
    private var descriptionImages:[UIImage] = []
    {
        didSet {
            NSLayoutConstraint.deactivate([tableHeight!])
            tableHeight = descriptionTableView.heightAnchor.constraint(equalToConstant: CGFloat(descriptionImages.count * 116))
            NSLayoutConstraint.activate([tableHeight!])
            descriptionTableView.reloadData()
            mainScrollView.updateContentSize()
            if descriptionImages.count > previousDataCount {
                mainScrollView.scrollToBottom()
            }
            previousDataCount = descriptionImages.count
        }
    }
    private var addIndex:Int = 0
    private var deleteImageURL:[String] = []
    private var completeCount: Int = 0
    private var isMainImageChanged: Bool = false
    /// init (nil, nil, []) : 이경우는 작성, / init(curation, mainImage, descriptionImages): 는 수정
    init(_ curation: Curation?,_ mainImage: UIImage?,_ descriptionImage: [UIImage]) {
        if let curation = curation {
            self.curation = curation
            self.mainImage = mainImage!
            self.descriptionImages = descriptionImage
            self.addIndex = descriptionImage.count
        } else {
            self.curation = Curation(userID: UserManager().getID(), bookstoreID: "", category: "" , mainImage: "", title: "", subTitle: "", headText: "", descriptions: [], likes: [], commentCount: 0)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // 데이터 갯수가 변경이 될 경우 이전 갯수와 비교하여 많을 경우 needToScroll을 바꾸며 스크롤을 통제
    private var previousDataCount: Int = 0
    
    // TextView를 클릭했을 경우 스크롤 이동이 필요한 경우인지 아닌지 확인하기 위함
    private var needToScroll:Bool = false
    // 텍스트뷰 클릭시 이동해야할 스크롤 위치값
    private var offset: CGFloat = 0
    
    // imagePicker에서 어디에 사진을 추가할지 확인하기 위한 기준
    private var imagePickerOpenSource: String = ""
    
    lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(buttonPressed(_:)))
        button.tag = 1
        return button
    } ()
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(buttonPressed(_:)))
        button.tag = 2
        return button
    } ()
    
    // TextView에 PlaceHolder 값
    private let headTextViewPlaceHolder: String = "본문 내용을 작성해 주세요"
    private let descriptionTextViewPlaceHolder: String = "사진 설명을 입력해 주세요"
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    } ()
    
    private let titleView: CurationCreateTitleView = {
        let view = CurationCreateTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let headTextView: CurationCreateHeadTextView = {
        let view = CurationCreateHeadTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let descriptionTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    } ()
    
    private let addDescriptionButton: CurationCreateAddDescriptionButton = {
        let button = CurationCreateAddDescriptionButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private let keyboardView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 0.1
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Set it to the left of the navigation bar.
        self.navigationItem.leftBarButtonItem = self.leftButton
        // Set it to the right of the navigation bar.
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.navigationController?.navigationBar.tintColor = .black
        
        mainScrollView.delegate = self
        descriptionTableView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        headTextView.setupDelegate(self, self)
        titleView.delegate = self
        addDescriptionButton.delegate = self
        
        // MARK: 키보드 나타나는 것을 감지
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // 텍스트 수정 중 키보드 영역 외에 터치시 키보드를 내리게 하기 위함
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        mainScrollView.addGestureRecognizer(singleTapGestureRecognizer)
        setupScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let mainImage = mainImage {
            titleView.setupImage(mainImage)
        } else {
            self.rightButton.isEnabled = false
            selectCategory()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupScrollView() {
        mainScrollView.addSubview(titleView)
        mainScrollView.addSubview(headTextView)
        mainScrollView.addSubview(descriptionTableView)
        mainScrollView.addSubview(addDescriptionButton)
        mainScrollView.addSubview(keyboardView)
        view.addSubview(mainScrollView)
        NSLayoutConstraint.activate([
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainScrollView.widthAnchor.constraint(equalToConstant: view.frame.width),
        ])
        setupTitleView()
        setupHeadTextView()
        setupDescriptionTableView()
        setupAddButton()
        setupKeyboardView()
        mainScrollView.updateContentSize()
    }
    
    private func setupTitleView() {
        titleView.setupTittleTest(main: curation.title, sub: curation.subTitle ?? "")
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            titleView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            titleView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            titleView.widthAnchor.constraint(equalToConstant: view.frame.width),
            titleView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.9435897)
        ])
    }
    
    private func setupHeadTextView() {
        if !curation.category.isEmpty {
            headTextView.setupCategory(curation.category)
        }
        headTextView.setupText(string: curation.headText)
        NSLayoutConstraint.activate([
            headTextView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            headTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headTextView.heightAnchor.constraint(equalToConstant: 338)
        ])
    }
    
    private func setupDescriptionTableView() {
        descriptionTableView.register(CurationCreateDescriptionTableViewCell.self, forCellReuseIdentifier: CurationCreateDescriptionTableViewCell.identifier)
        descriptionTableView.allowsSelection = false
        let height = CGFloat(descriptionImages.count * 116)
        tableHeight = descriptionTableView.heightAnchor.constraint(equalToConstant: height)
        NSLayoutConstraint.activate([
            descriptionTableView.topAnchor.constraint(equalTo: headTextView.bottomAnchor),
            descriptionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableHeight!
        ])
    }
    
    private func setupAddButton() {
        NSLayoutConstraint.activate([
            addDescriptionButton.heightAnchor.constraint(equalToConstant: 100),
            addDescriptionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addDescriptionButton.widthAnchor.constraint(equalToConstant: 100),
            addDescriptionButton.topAnchor.constraint(equalTo: descriptionTableView.bottomAnchor, constant: 16),
        ])
        
    }
    
    // MARK: 키보드 가림을 피하기 위한 View
    private func setupKeyboardView() {
        keyboardHeightAnchor = keyboardView.heightAnchor.constraint(equalToConstant: keyboardHeight)
        NSLayoutConstraint.activate([
            keyboardHeightAnchor!,
            keyboardView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            keyboardView.topAnchor.constraint(equalTo: addDescriptionButton.bottomAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor)
        ])
    }
    
    // MARK: PHPickerViewController Present
    func presentPHPicker() {
        DispatchQueue.main.async {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    // 키보드 올라올 경우 키보드 높이값을 확인해서 변수에 저장
    @objc private func handle(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, self.keyboardHeight == 0 {
            self.keyboardHeight = keyboardRectangle.height
        }
    }
    
    // view 터치시 키보드 내리기
    @objc private func endEdit() {
        view.endEditing(true)
    }
    
    // Navbar Button Item Handler
    @objc private func buttonPressed(_ sender: Any) {
        if let button = sender as? UIBarButtonItem {
            switch button.tag {
                //BackButton Action
            case 1:
                let alert = UIAlertController(title: nil, message: "작성 중인 내용을\n 저장 하지 않고 나가시겠습니까?", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                let complete = UIAlertAction(title: "나가기", style: .destructive, handler: { _ in
                    guard let _ = self.navigationController?.popViewController(animated: true) else {
                        self.dismiss(animated: true)
                        return
                    }
                })
                alert.addAction(cancel)
                alert.addAction(complete)
                present(alert, animated: true, completion: nil)
                
                //CompleteButton Action
            case 2:
                // Change the background color to red.
                rightButton.isEnabled = false
                view.endEditing(true)
                for url in deleteImageURL {
                    do {
                        try CurationRequest().deleteCurationImage(url: url)
                    } catch {
                        print("delete Error")
                    }
                }
                if isMainImageChanged {
                    CurationRequest().uploadCurationImage(image: mainImage ?? UIImage(), pathRoot: "Curations/\(curation.title)/main", completion: { url in
                        self.curation.mainImage = url ?? ""
                        self.completeCount += 1
                        if self.completeCount == self.descriptionImages.count {
                            do {
                                try CurationRequest().add(self.curation)
                                var newImages: [UIImage] = []
                                newImages.append(self.mainImage ?? UIImage())
                                newImages.append(contentsOf: self.descriptionImages)
                                self.newImageAndCuration(newImages, self.curation)
                                guard let _ = self.navigationController?.popViewController(animated: true) else {
                                    self.dismiss(animated: true)
                                    return
                                }
                            } catch {
                                print("erroe curation add")
                            }
                        }
                    })
                }
                if descriptionImages.isEmpty {
                    do {
                        try CurationRequest().add(self.curation)
                        var newImages: [UIImage] = []
                        newImages.append(self.mainImage ?? UIImage())
                        self.newImageAndCuration(newImages, self.curation)
                        self.dismiss(animated: true)
                        guard let _ = self.navigationController?.popViewController(animated: true) else {
                            return
                        }
                    } catch {
                        print("erroe curation add")
                    }
                }
                else {
                    for i in 0..<descriptionImages.count {
                        if addIndex <= i {
                            CurationRequest().uploadCurationImage(image: descriptionImages[i], pathRoot: "Curations/\(curation.title)/descriptions") { url in
                                self.curation.descriptions[i].image = url
                                self.completeCount += 1
                                if self.completeCount == self.descriptionImages.count {
                                    do {
                                        try CurationRequest().add(self.curation)
                                        var newImages: [UIImage] = []
                                        newImages.append(self.mainImage ?? UIImage())
                                        newImages.append(contentsOf: self.descriptionImages)
                                        self.newImageAndCuration(newImages, self.curation)

                                        guard let _ = self.navigationController?.popViewController(animated: true) else {
                                            self.dismiss(animated: true)
                                            
                                            return
                                        }
                                    } catch {
                                        self.rightButton.isEnabled = true
                                    }
                                }
                            }
                        } else {
                            self.completeCount += 1
                            if i == descriptionImages.count - 1 {
                                do {
                                    try CurationRequest().add(self.curation)
                                    var newImages: [UIImage] = []
                                    newImages.append(self.mainImage ?? UIImage())
                                    newImages.append(contentsOf: self.descriptionImages)
                                    self.newImageAndCuration(newImages, self.curation)
                                    guard let _ = self.navigationController?.popViewController(animated: true) else {
                                        self.dismiss(animated: true)
                                        return
                                    }
                                } catch {
                                    self.rightButton.isEnabled = true
                                }
                            }
                        }
                    }
                }
            default:
                print("error")
            }
        }
    }
    
    // 완료 버튼 활성화를 판단해주는 함수
    private func checkIsEnable() {
        if !curation.title.isEmpty && !curation.headText.isEmpty && mainImage != nil && !curation.category.isEmpty {
            self.rightButton.isEnabled = true
        } else {
            self.rightButton.isEnabled = false
        }
    }
    
}

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

// MARK: 동적 셀 높이 변화에 따른 ScrollView의 Scroll 높이를 조정해주는 Extension > 리팩토링 시 extension으로 빼기
extension UIScrollView {
    func updateContentSize() {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
        // 계산된 크기로 컨텐츠 사이즈 설정
        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height+50)
    }
    
    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero
        
        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }
        
        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }
    
    public func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
    public func scrollToTextView(_ offset: CGFloat, height: CGFloat, keyboardHeight: CGFloat) {
        let bottomOffset = CGPoint(x:0, y: offset - (height - keyboardHeight))
        setContentOffset(bottomOffset, animated: true)
    }
}

extension CurationCreateViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass:  UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
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
                            self.completeCount -= 1
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
            if let text = textView.text, text == descriptionTextViewPlaceHolder && textView.textColor == UIColor.kindyGray  {
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

extension CurationCreateViewController: CurationCreateDelegate {
    
    ///키보드 높이를 0으로 만들어 줌
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

