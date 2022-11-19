//
//  ImageCache.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/14.
//

import UIKit

enum ImageRequestError: Error {
    case invalidURL
    case imageDataMissing
    case couldNotInitializeFromData
}

final class ImageCache {
    
    static let cache = ImageCache()
    private init() { }
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    // 캐시된 이미지가 있다면 리턴하고, 없다면 비동기적으로 로드 한 뒤 캐싱
    func load(url: String?) async throws -> UIImage {
        // url 생성 후 캐시된 이미지 있는지 확인
        guard let string = url else { return UIImage() }
        guard let url = NSURL(string: string) else { throw ImageRequestError.invalidURL }
        if let cachedImage = image(url: url) { return cachedImage }
        
        let (data, response) = try await URLSession.shared.data(from: url as URL)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ImageRequestError.imageDataMissing }
        
        guard let image = UIImage(data: data) else { throw ImageRequestError.couldNotInitializeFromData }
        cachedImages.setObject(image, forKey: url)
        
        return image
    }
}
