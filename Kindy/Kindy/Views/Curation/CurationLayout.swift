//
//  CurationLayout.swift
//  Kindy
//
//  Created by rbwo on 2022/10/21.
//

import UIKit

final class CurationLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /// 셀 헤더의 늘어나는 효과 구현
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        guard let offset = collectionView?.contentOffset, let stLayoutAttributes = layoutAttributes else {
            return layoutAttributes
        }
        
        if offset.y < 0 {
            for attributes in stLayoutAttributes where attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                let diffValue = abs(offset.y)
                
                var frame = attributes.frame
                frame.size.height = max(0, headerReferenceSize.height + diffValue)
                frame.origin.y = frame.minY - diffValue
                attributes.frame = frame
            }
        }
        
        else {
            for attributes in stLayoutAttributes where attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                let diffValue = abs(offset.y)
                var frame = attributes.frame
                frame.size.height = max(0, headerReferenceSize.height - diffValue)
                frame.origin.y = frame.minY + diffValue
                attributes.frame = frame
            }
        }
        return layoutAttributes
    }
}
