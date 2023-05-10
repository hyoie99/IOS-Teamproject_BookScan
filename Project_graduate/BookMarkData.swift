//
//  BookMarkData.swift
//  Project_graduate
//
//  Created by 윤한솔 on 2023/05/10.
//

import Foundation

class BookMarkData {
    static let shared = BookMarkData()
    
    var bookmarkArray: [String] = []
    
    func addBookmark(withKey key: String) {
        // 북마크 배열에 키를 추가
        bookmarkArray.append(key)
    }
    
    func removeBookmark(withKey key: String) {
        // 북마크 배열에서 키를 삭제
        if let index = bookmarkArray.firstIndex(of: key) {
            bookmarkArray.remove(at: index)
        }
    }
}
