//
//  SortModel.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/08.
//

import Foundation

// MARK: - 정렬
struct Order {
    let sortName = ("정렬", "order")
    let recent = ("최신순", "recent")
    let best = ("베스트", "best")
    let popular = ("인기순", "popular")
}

// MARK: - 공간
struct Space {
    let sortName = ("공간", "space")
    let livingroom = ("거실", 1)
    let bedroom = ("침실", 2)
    let kitchen = ("주방", 3)
    let bathroom = ("욕실", 4)
}

// MARK: - 주거형태
struct Residence {
    let sortName = ("주거형태", "residence")
    let apartment = ("아파트", 1)
    let villa = ("빌라&연립", 2)
    let house = ("단독주택", 3)
    let office = ("사무공간", 4)
}
