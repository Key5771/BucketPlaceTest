//
//  SortModel.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/08.
//

import Foundation

// MARK: - 정렬 정보를 넘겨주기 위한 델리게이트
protocol PassDataDelegate {
    func passData(data: (String, (String, String)))
}

// MARK: - 정렬
struct Order {
    let sortName = ("정렬", "order")
    let recent = ("최신순", ("order", "recent"))
    let best = ("베스트", ("order", "best"))
    let popular = ("인기순", ("order", "popular"))
}

// MARK: - 공간
struct Space {
    let sortName = ("공간", "space")
    let livingroom = ("거실", ("space", "1"))
    let bedroom = ("침실", ("space", "2"))
    let kitchen = ("주방", ("space", "3"))
    let bathroom = ("욕실", ("space", "4"))
}

// MARK: - 주거형태
struct Residence {
    let sortName = ("주거형태", "residence")
    let apartment = ("아파트", ("residence", "1"))
    let villa = ("빌라&연립", ("residence", "2"))
    let house = ("단독주택", ("residence", "3"))
    let office = ("사무공간", ("residence", "4"))
}
