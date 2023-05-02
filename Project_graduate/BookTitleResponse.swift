//
//  BookTitleResponse.swift
//  Project_graduate
//
//  Created by 윤한솔 on 2023/04/30.
//

import Foundation

struct BookTitleResponse: Decodable {
    let result: BookResult

    struct BookResult: Decodable {
        let imageUrl: String
    }
}

