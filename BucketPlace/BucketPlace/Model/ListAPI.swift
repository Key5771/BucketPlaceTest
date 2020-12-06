//
//  ListAPI.swift
//  BucketPlace
//
//  Created by 김기현 on 2020/12/06.
//

import Foundation

struct ListAPI: Decodable {
    let id: Int?
    let image_url: String?
    let nickname: String?
    let profile_image_url: String?
    let description: String?
}
