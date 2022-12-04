//
//  CurationCreateViewController.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/11/20.
//

import UIKit
import PhotosUI

final class CurationCreateViewController: UIViewController {
    
    var curationImagesTask: Task<Void, Never>?
    // descriptionTable의 높이를 변화시키기 위한 변수
    var tableHeight: NSLayoutConstraint?
    
    typealias newImageAndCuration = ([UIImage], Curation) -> Void
    var newImageAndCuration: newImageAndCuration!
    
    var keyboardHeight: CGFloat = 0 {
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
    
    var curation:Curation {
        didSet {
            checkIsEnable()
        }
    }
    var mainImage:UIImage? {
        didSet {
            checkIsEnable()
        }
    }
    
    // 이미지 갯수가 달라지면 tableView의 높이 변화를 주고, scrollView의 scroll범위 값을 다시 설정해준다
    var descriptionImages:[UIImage] = []
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
    var addIndex:Int = 0
    var deleteImageURL:[String] = []
    var isMainImageChanged: Bool = false
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
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        curationImagesTask?.cancel()
    }
    
    // 데이터 갯수가 변경이 될 경우 이전 갯수와 비교하여 많을 경우 needToScroll을 바꾸며 스크롤을 통제
    var previousDataCount: Int = 0
    
    // TextView를 클릭했을 경우 스크롤 이동이 필요한 경우인지 아닌지 확인하기 위함
    var needToScroll:Bool = false
    // 텍스트뷰 클릭시 이동해야할 스크롤 위치값
    var offset: CGFloat = 0
    
    // imagePicker에서 어디에 사진을 추가할지 확인하기 위한 기준
    var imagePickerOpenSource: String = ""
    
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
    let headTextViewPlaceHolder: String = "본문 내용을 작성해 주세요"
    let descriptionTextViewPlaceHolder: String = "사진 설명을 입력해 주세요"
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    } ()
    
    let titleView: CurationCreateTitleView = {
        let view = CurationCreateTitleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let headTextView: CurationCreateHeadTextView = {
        let view = CurationCreateHeadTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    let descriptionTableView: UITableView = {
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
            var category = ""
            switch curation.category {
            case "bookstore":
                category = "서점"
            case "book":
                category = "도서"
            default:
                category = curation.category
            }
            headTextView.setupCategory(category)
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
                self.toogleOfScreenInteractionMode(bool: false)
                view.endEditing(true)
                for url in deleteImageURL {
                    do {
                        try CurationRequest().deleteImage(url: url)
                    } catch {
                        print("delete Error")
                    }
                }
                self.imageUpload()
                
            default:
                print("error")
            }
        }
    }
    
    // Image Upload Function
    func imageUpload()  {
        self.toogleOfScreenInteractionMode(bool: false)
        view.endEditing(true)
        curationImagesTask?.cancel()
        curationImagesTask = Task {
            if isMainImageChanged {
                guard let imageURL = try? await CurationRequest().asyncUploadImage(image:  mainImage ?? UIImage(), pathRoot: "Curations/\(curation.title)/main") else {
                    self.alertError(message: "사진 업로드 중 문제가 발생하였습니다.\n 잠시 후 다시 시도해 주세요")
                    return
                }
                self.curation.mainImage = imageURL            }

            if !descriptionImages.isEmpty {
                for i in 0..<self.descriptionImages.count {
                    if addIndex <= i {
                        let image = self.descriptionImages[i]
                        guard let imageURL = try? await CurationRequest().asyncUploadImage(image: image, pathRoot: "Curations/\(curation.title)/descriptions") else {
                            self.alertError(message: "사진 업로드 중 문제가 발생하였습니다.\n 잠시 후 다시 시도해 주세요")
                            return
                        }
                        self.curation.descriptions[i].image = imageURL
                    }
                }
            }
            self.completeAction()
            curationImagesTask = nil
        }
    }
    
    // Image Upload 완료 후 Curation 데이터 upload function
    private func completeAction() {
        do {
            try CurationRequest().add(self.curation)
            var newImages: [UIImage] = []
            newImages.append(self.mainImage ?? UIImage())
            newImages.append(contentsOf: self.descriptionImages)
            self.newImageAndCuration(newImages, self.curation)
            self.toogleOfScreenInteractionMode(bool: true)
            guard let _ = self.navigationController?.popViewController(animated: true) else {
                self.dismiss(animated: true)
                return
            }
        } catch {
            self.toogleOfScreenInteractionMode(bool: true)
            self.alertError(message: "작성 중 문제가 발생하였습니다.\n 잠시 후 다시 시도해 주세요")
        }
    }
    
    private func toogleOfScreenInteractionMode(bool: Bool) {
        self.rightButton.isEnabled = bool
        self.leftButton.isEnabled = bool
        self.view.isUserInteractionEnabled = bool
    }
    
    // 문제 발생시 에러 메시지를 발생시키기 위한 함수
    private func alertError(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(cancel)
        present(alert ,animated: true, completion: nil)
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

