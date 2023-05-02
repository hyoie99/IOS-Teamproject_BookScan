//
//  ImageDataManager.swift
//  Project_graduate
//
//  Created by 윤한솔 on 2023/05/02.
//

import Foundation

class ImageDataManager {
    // 싱글톤 패턴을 사용하여 앱 전체에서 하나의 인스턴스를 공유할 수 있도록 설정 (by using UserDefault)
    static let shared = ImageDataManager()

    private init() {}

    //url 저장
    func saveImageUrl(_ imageUrl: String) {
        let defaults = UserDefaults.standard
        defaults.set(imageUrl, forKey: "savedImageUrl")
    }
    //url 저장된거 꺼내기
    func fetchSavedImageUrl() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "savedImageUrl")
    }
    /*
     앱의 모든 UserDefaults 키-값 쌍이 삭제
     UserDefaults.standard.removeObject(forKey: "imageURL")
     if let bundleIdentifier = Bundle.main.bundleIdentifier {
         UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
     }

     */
}
