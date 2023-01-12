import UIKit

enum Padding {
    static let eight: CGFloat = 8
    static let sixteen: CGFloat = 16
    static let twentyFour: CGFloat = 24
}

enum Inset {
    static let leadingSixteen = NSDirectionalEdgeInsets(
        top: .zero,
        leading: Padding.sixteen,
        bottom: .zero,
        trailing: .zero
    )

    static let topBottomEight = NSDirectionalEdgeInsets(
        top: Padding.eight,
        leading: .zero,
        bottom: Padding.eight,
        trailing: .zero
    )

    static let topBottomSixteen = NSDirectionalEdgeInsets(
        top: .zero,
        leading: Padding.sixteen,
        bottom: .zero,
        trailing: Padding.sixteen
    )
}

enum Size {
    static let full = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
    )

    static let header = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .estimated(36)
    )
}
