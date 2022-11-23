//
//  BookmarkDelegate.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/10/23.
//

import Foundation

// 북마크 삭제시 BookmarkCollectionViewCell 에 전달할 함수
protocol BookmarkDelegate: AnyObject {
    func deleteBookmark(_ deleteItem: Bookstore)
    func selectItem(_ bookstore: Bookstore)
}
