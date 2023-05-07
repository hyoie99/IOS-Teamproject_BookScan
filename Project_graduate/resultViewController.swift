//
//  resultVC.swift
//  api3
//
//  Created by 이혜인 on 2023/05/06.
//

import UIKit
import Alamofire

class resultViewController: UIViewController {
    
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var authorView: UILabel!
    @IBOutlet weak var priceView: UILabel!
    
    @IBOutlet weak var kyoboReview: UITextView!
    @IBOutlet weak var kyobomore: UIButton!
    var fullReviewText1: String = ""
    
    @IBOutlet weak var yes24Review: UITextView!
    @IBOutlet weak var yes24more: UIButton!
    var fullReviewText2: String = ""
    
//    var searchQuery: String?
    var searchQuery = TitleManager.shared.Title
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("resultVC called")
        
        if let searchQuery = searchQuery {
                    print("Search query: \(searchQuery)")
                } else {
                    print("Search query is nil.")
            }
        
        indicatorfunc()
        getReviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            // 책 이미지 불러오기
            if let urlString = BookData.shared.imageUrl, let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.imageView.image = image
                    }
                }.resume()
            }
            
            // 교보 리뷰 불러오기
            let reviewText = BookData.shared.kyoboInfo?["review"] as? String ?? ""
            if reviewText.count > 180 {
                self.fullReviewText1 = reviewText
                let index = reviewText.index(reviewText.startIndex, offsetBy: 200)
                let truncatedText = String(reviewText[..<index]) + "..."
                self.kyoboReview.text = truncatedText
                self.kyobomore.isHidden = false
            } else {
                self.kyoboReview.text = reviewText
                self.kyobomore.isHidden = true
            }
            
            // yes24 리뷰 불러오기
            let reviewText2 = BookData.shared.yes24Info?["review"] as? String ?? ""
            if reviewText2.count > 180 {
                self.fullReviewText2 = reviewText2
                let index = reviewText2.index(reviewText2.startIndex, offsetBy: 200)
                let truncatedText = String(reviewText2[..<index]) + "..."
                self.yes24Review.text = truncatedText
                self.yes24more.isHidden = false
            } else {
                self.yes24Review.text = reviewText2
                self.yes24more.isHidden = true
            }
        }
    }
    
    func indicatorfunc(){
        searchIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0){
            self.searchIndicator.isHidden = true
            self.searchIndicator.stopAnimating()
        }
    }
    
    func getReviews(){
//        let url = "http://3.39.106.142:8080/book/info"
//        let url = "http://43.201.164.78:8080/book/info"
        let url = "http://3.38.6.240:8080/book/info"
        let param = ["bookTitle": searchQuery]
        AF.request(url, method: .get, parameters: param).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success(let value):
                guard let json = value as? [String: Any] else { return }
                if let resultData = json as? [String: Any] {
//                    print(resultData)
                    if let parseData = resultData["result"] as? [String: Any] {
                        // imageUrl
                        if let imageUrl = parseData["imageUrl"] as? String {
                            BookData.shared.imageUrl = imageUrl
                        }
                        // KyoboInfo
                        if let kyoboInfo = parseData["kyoboInfo"] as? [String: Any] {
                            if let review = kyoboInfo["review"], let bookUrl = kyoboInfo["bookUrl"], let price = kyoboInfo["rowPrice"], let title = kyoboInfo["title"], let author = kyoboInfo["author"] {
                                BookData.shared.kyoboInfo = ["review": review, "bookUrl": bookUrl, "price": price, "title": title, "author": author]
                                self.titleView.text = title as? String
                                self.authorView.text = author as? String
                                self.priceView.text = price as? String
                            }
                        }
                        // yes24Info
                        if let yes24Info = parseData["yes24Info"] as? [String: Any] {
                            if let review = yes24Info["review"], let bookUrl = yes24Info["bookUrl"] {
                                BookData.shared.yes24Info = ["review": review, "bookUrl": bookUrl]
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    @IBAction func kyoboMoreClicked(_ sender: Any) {
        kyoboReview.text = fullReviewText1
        kyobomore.isHidden = true
    }
    @IBAction func yesMoreClicked(_ sender: Any) {
        yes24Review.text = fullReviewText2
        yes24more.isHidden = true
    }
}

class BookData {
    static let shared = BookData()
    
    var imageUrl: String?
    var kyoboInfo: [String: Any]?
    var yes24Info: [String: Any]?
}
