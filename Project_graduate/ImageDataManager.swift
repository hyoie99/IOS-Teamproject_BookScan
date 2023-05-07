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
        var urls = defaults.array(forKey: "savedImageUrl") as? [String] ?? [String]()
        urls.append(imageUrl)
        defaults.set(urls, forKey: "savedImageUrl")
    }
    //url 저장된거 꺼내기
    func fetchSavedImageUrl(at index: Int) -> String? {
        let defaults = UserDefaults.standard
        let urls = defaults.array(forKey: "savedImageUrl") as? [String] ?? [String]()
        if urls.count > index {
            return urls[index]
        }
        return nil
    }
    // url 모두 꺼내기
    func fetchAllSavedImageUrls() -> [String] {
        let defaults = UserDefaults.standard
        return defaults.array(forKey: "savedImageUrl") as? [String] ?? [String]()
    }
    
    // 제목 저장
    func saveTitle(_ title: String) {
        let defaults = UserDefaults.standard
        var titles = defaults.array(forKey: "savedTitles") as? [String] ?? [String]()
        titles.append(title)
        defaults.set(titles, forKey: "savedTitles")
    }
    // 저장된 제목 꺼내기
    func fetchSavedTitle(at index: Int) -> String? {
        let defaults = UserDefaults.standard
        let titles = defaults.array(forKey: "savedTitles") as? [String] ?? [String]()
        if titles.count > index {
            return titles[index]
        }
        return nil
    }


    /*
     앱의 모든 UserDefaults 키-값 쌍이 삭제
     UserDefaults.standard.removeObject(forKey: "imageURL")
     if let bundleIdentifier = Bundle.main.bundleIdentifier {
         UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier)
     }

     */
}
