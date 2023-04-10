//
//  TitleListViewController.swift
//  Project_graduate
//
//  Created by 윤한솔 on 2023/04/10.
//

import UIKit
import Alamofire
import SwiftyJSON

class TitleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let titles = [
        "세이노의 가르침",
        "나는 어떻게 행복할 수 있는가",
        "스즈메의 문단속",
        "표류하는 세계",
        "우울한 마음도 습관입니다"
    ]
    var bookTitles = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell",for: indexPath) as! MyTableViewCell
        cell.sendTitleButton.setTitle(titles[indexPath.row], for: .normal)
        //        cell.sendTitleButton.setTitle(bookTitles[indexPath.row], for: .normal)
        //나중에 서버 연결시 위 코드 titles -> bookTitles 로 고치기
        //        cell.layer.borderWidth = 2
        //        cell.layer.borderColor = UIColor.black.cgColor
        cell.sendTitleButton.layer.cornerRadius = 5
        cell.sendTitleButton.layer.borderWidth = 2
        cell.sendTitleButton.layer.borderColor = UIColor.black.cgColor
        cell.sendTitleButton.frame = CGRect(x: 0, y: 0, width: 298, height: 46)
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //        downloadTitle()
        self.tableView.rowHeight = 60
        
    }
    
    
    //서버로 부터 다운로드.
    func downloadTitle()  {
        guard let url = URL(string: "https://c01eab03-f973-428e-8317-46eb33df96eb.mock.pstmn.io/list") else {
            return
        }
        //        AF.request(url).validate().responseJSON (completionHandler:{ (response) in
        //            print(response)
        //            //json 결과 파싱
        //            self.parseJSON(response)
        //           //bookTitle에 결과 넣기
        //        })
        AF.request(url).responseJSON { response in
            switch response.result {
            case.success(let value) :
                let json = JSON(value)
                self.bookTitles.append(contentsOf: json["Titles"].arrayValue.map({$0.stringValue}))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
