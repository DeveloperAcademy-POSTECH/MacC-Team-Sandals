//
//  ImageCache.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/14.
//

import UIKit

final actor ImageCache {
    static let shared = ImageCache()
    private init() {
        createDirectoryIfNeeded()
    }
    
    private let cachedImages: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    // 디스크에 이미지가 저장되는 디렉토리
    private let directoryName = "Kindy_Images"
}

// MARK: 이미지 로드
extension ImageCache {

    enum ImageRequestError: Error {
        case invalidURL
        case imageDataMissing
        case couldNotInitializeFromData
    }
    
    /// 메모리, 디스크 캐싱하는 함수
    func load(_ url: String?) async throws -> UIImage? {
        guard let urlString = url,
              let url = NSURL(string: urlString),
              let fileName = createFileName(with: url.pathComponents)
        else { throw ImageRequestError.invalidURL }
        
        // 메모리 확인
        if let image = checkMemory(with: url) {
            return image
        } else if let image = checkDisk(with: fileName) {
            // 메모리에 캐시된 이미지 없다면 디스크 확인
            // 디스크에 저장된 이미지 있다면 메모리에 저장 후 리턴
            guard let preparedImage = await image.resize else { return nil }
            saveToMemory(preparedImage, key: url)
        }
        
        // 메모리, 디스크 모두에 이미지 없다면 fetch
        let (data, response) = try await URLSession.shared.data(from: url as URL)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ImageRequestError.imageDataMissing }
        
        guard let image = UIImage(data: data) else { throw ImageRequestError.couldNotInitializeFromData }
        guard let preparedImage = await image.resize else { return nil }
        
        // fetch 후 메모리와 디스크에 이미지 저장
        saveToMemory(preparedImage, key: url)
        saveToDisk(image, name: fileName)
        
        return preparedImage
    }
    
    ///  커뮤니티 게시글에서 사용하는 메모리 캐싱만 하는 함수
    func loadFromMemory(_ url: String?) async throws -> UIImage? {
        guard let urlString = url,
              let url = NSURL(string: urlString)
        else { throw ImageRequestError.invalidURL }
        
        // 메모리 확인
        if let image = checkMemory(with: url) { return image }
        
        // 메모리에 이미지 없다면 fetch
        let (data, response) = try await URLSession.shared.data(from: url as URL)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ImageRequestError.imageDataMissing }
        
        guard let image = UIImage(data: data) else { throw ImageRequestError.couldNotInitializeFromData }
        guard let preparedImage = await image.resize else { return nil }
        
        saveToMemory(preparedImage, key: url)
        
        return preparedImage
    }
}

// MARK: 메모리 캐싱
extension ImageCache {
    // 메모리에서 이미지 로드
    private func checkMemory(with url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    // 메모리에 이미지 캐싱
    private func saveToMemory(_ image: UIImage, key: NSURL) {
        cachedImages.setObject(image, forKey: key)
    }
}

// MARK: 디스크 캐싱
extension ImageCache {
    // 디스크에서 이미지 로드
    private func checkDisk(with name: String) -> UIImage? {
        guard let path = getFilePath(with: name)?.path else { return nil }
        
        if FileManager.default.fileExists(atPath: path) {
            return UIImage(contentsOfFile: path)
        } else {
            return nil
        }
    }
    
    // 디스크에 이미지 저장
    private func saveToDisk(_ image: UIImage, name: String) {
        guard let data = image.jpegData(compressionQuality: 0.7),
              let path = getFilePath(with: name)
        else { return }
        
        try? data.write(to: path)
    }
    
    // 디스크에 우리 앱 폴더 생성
    nonisolated private func createDirectoryIfNeeded() {
        guard let path = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent(directoryName)
            .path
        else { return }
        
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
    }
    
    // 디스크의 이미지 디렉토리 삭제
    nonisolated func deleteDirectory() {
        guard let path = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent(directoryName)
            .path
        else { return }
        
        try? FileManager.default.removeItem(atPath: path)
    }
}

// MARK: Helper functions
extension ImageCache {
    // Firebase에 저장된 (폴더 이름 + 이미지 이름)으로 파일 이름 생성 (이미지 이름으로만 파일 이름을 지정하게 되면 중복 가능성이 존재하기 때문)
    private func createFileName(with urlComponents: [String]?) -> String? {
        guard let urlComponents = urlComponents else { return nil }
        let array = Array(urlComponents.suffix(2))
        let fileName = array[0] + "-" + array[1]
        return fileName
    }
    
    // 캐시 디렉토리의 파일 경로 리턴
    private func getFilePath(with name: String) -> URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent(directoryName)
            .appendingPathComponent(name)
    }
}

// MARK: 여러장의 이미지를 동시에 load 하는 함수들
extension ImageCache {
    func loadImageDictionary(URLs: [String]) async throws -> [String : UIImage] {
        try await withThrowingTaskGroup(of: (String, UIImage).self) { group in
            for url in URLs {
                group.addTask {
                    let image = try? await ImageCache.shared.load(url)
                    return (url, image ?? UIImage())
                }
            }
            var images = [String : UIImage]()
            
            for try await (url, image) in group {
                images[url] = image
            }
            return images
        }
    }
    
    func loadImageArray(URLs: [String]) async throws -> [UIImage] {
        let images: [UIImage] = try await URLs.concurrentMap { url in
            return try await ImageCache.shared.load(url) ?? UIImage()
        }
        return images
    }
}
