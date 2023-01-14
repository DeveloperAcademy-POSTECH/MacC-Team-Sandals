import UIKit

extension UIImage {
    /// 이미지의 크기만 바꿔줌
    func resizeImage(size: CGSize) -> UIImage {
        let originalSize = self.size

        var ratio: CGFloat {
            originalSize.width > originalSize.height ?
            1 / (size.width / originalSize.width) : 1 / (size.height / originalSize.height)
        }

        return UIImage(cgImage: cgImage!, scale: scale * ratio, orientation: imageOrientation)
    }

    /// 이미지 다운샘플링
    var resize: UIImage? {
        get async {
            if #available(iOS 15.0, *) {
                return await self.byPreparingThumbnail(ofSize: size)
            } else {
                return self
            }
        }
    }
}
