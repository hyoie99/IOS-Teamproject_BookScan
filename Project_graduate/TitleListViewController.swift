//
//  TitleListViewController.swift
//  Project_graduate
//
//  Created by 윤한솔 on 2023/04/10.
//

import UIKit
import Alamofire
import SwiftyJSON

class TitleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, customTableViewCellDelegate {
    let titles = [
        "세이노의 가르침",
        "나는 어떻게 행복할 수 있는가",
        "스즈메의 문단속",
        "표류하는 세계",
        "우울한 마음도 습관입니다"
    ]
//    var bookTitles = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return titles.count
        // 통신 x시 titles.count 통신 o 시 self.stringArray.count
        return self.stringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell",for: indexPath) as! MyTableViewCell
//        downloadTitle()
//        cell.sendTitleButton.setTitle(titles[indexPath.row], for: .normal)
        
        
        cell.sendTitleButton.setTitle(self.stringArray[indexPath.row], for: .normal)
        //나중에 서버 연결시 위 코드 titles -> bookTitles 로 고치기
        
        
        cell.sendTitleButton.layer.cornerRadius = 5
        cell.sendTitleButton.layer.borderWidth = 2
        cell.sendTitleButton.layer.borderColor = UIColor.black.cgColor
        cell.sendTitleButton.frame = CGRect(x: 0, y: 0, width: 298, height: 46)
//        cell.indicatorActive = {
//            self.indicator.isHidden = false
//            self.indicator.startAnimating()
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
//                self.indicator.isHidden = true
//                self.indicator.stopAnimating()
//            }
//        }
        return cell
    }
    func didTapButtonCell() {
        let resultVC = resultViewController()
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    
    @IBAction func onbtnHome(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    } // 버튼 크기 확인 및 카메라로 돌아가는지 확인
    
    
    @IBAction func onBtnCam(_ sender: UIButton) {
        let controllers = self.navigationController?.viewControllers
        for newVC in controllers! {
            if newVC is CamViewController {
                //북마크에서 dismiss 한 뒤 present 하는 법 참고
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    let gb = UIColor(red: 0.0/255.0, green: 171.0/255.0, blue: 179.0/255.0, alpha: 1.0)
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonCam: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    private var stringArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
       
        self.tableView.rowHeight = 60
//        indicator.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.indicator.isHidden = true
            self.indicator.stopAnimating()
        }
        downloadTitle()
        
    }
    
    //서버로 부터 다운로드.
    func downloadTitle()  {
        guard let url = URL(string: "http://3.38.6.240:8080/book/title") else {
            return
        }
        let params : [String: Any] = [
            "titles" : ["string"]
        ]
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case.success(let value) :
                let json = JSON(value)
//                print(json)
                if let titleArray = json["titles"].array {
                    self.stringArray = titleArray.compactMap{$0.string}
                    print(self.stringArray)
                    print("title success")
                    self.tableView.reloadData() // 데이터가 로드되면 테이블 뷰를 리로드한다.
                } else {
                    print("JSON객체에서 titles 배열을 추출하는 데 실패했습니다.")
                    self.stringArray.append("제목을 찾지 못하였습니다. 다시시도해주세요.")
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    func fetchStringArray(completion: @escaping ([String]?) -> Void) {
        guard let url = URL(string: "https://example.com/data.json") else {
            print("URL 생성에 실패했습니다.")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("데이터를 가져오는 데 실패했습니다: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("데이터가 없거나 응답이 정상이 아닙니다.")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let stringArray = try decoder.decode([String].self, from: data)
                completion(stringArray)
            } catch {
                print("JSON 디코딩에 실패했습니다: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
        print("가져온 문자 배열: ,\(stringArray)")
    }

}
