//
//  Bookdata.swift
//  Project_graduate
//
//  Created by 윤한솔 on 2023/05/10.
//

import Foundation

class BookData {
    static let shared = BookData()
    
    var imageUrl: String?
    var kyoboInfo: [String: Any]?
    var yes24Info: [String: Any]?
}
