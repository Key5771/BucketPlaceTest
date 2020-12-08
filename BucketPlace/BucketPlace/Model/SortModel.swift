//
//  SortModel.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/08.
//

import Foundation

// MARK: - 정렬
struct Order {
    let sortName = "정렬"
    let recent = "최신순"
    let best = "베스트"
    let popular = "인기순"
}

// MARK: - 공간
struct Space {
    let sortName = "공간"
    let livingroom = "거실"
    let bedroom = "침실"
    let kitchen = "주방"
    let bathroom = "욕실"
}

// MARK: - 주거형태
struct Residence {
    let sortName = "주거형태"
    let apartment = "아파트"
    let villa = "빌라&연립"
    let house = "단독주택"
    let office = "사무공간"
}
