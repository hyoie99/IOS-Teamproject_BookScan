//
//  settingVC.swift
//  api3
//
//  Created by 이혜인 on 2023/05/09.
//

import UIKit

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("settingVC called")

    }
    
    // 히스토리 전체 삭제 버튼
    @IBAction func initHistory(_ sender: Any) {
        ImageDataManager.shared.removeAllImageUrls()
        ImageDataManager.shared.removeAllTitles()
    }
    
    
    // 북마크 전체 삭제 버튼
    @IBAction func initBookmark(_ sender: Any) {
        print("click initBookmark")
        let bookmarkArray = BookMarkData.shared.bookmarkArray
        
        for key in bookmarkArray {
            BookMarkData.shared.removeBookmark(withKey: key)
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
