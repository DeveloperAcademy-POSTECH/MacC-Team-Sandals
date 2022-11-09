//
//  Model.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/06.
//

import Foundation

struct Model {
    var curations = [ViewModel.Item]()
    var bookstores = [ViewModel.Item]()
    var featuredBookstores = [ViewModel.Item]()
    
    var regions: [ViewModel.Item] = [
        .region("전체"),
        .region("서울"),
        .region("경기/인천"),
        .region("강원"),
        .region("충청/대전"),
        .region("경북/대구"),
        .region("전라/광주"),
        .region("경남/울산/부산"),
        .region("제주")
    ]
}
