//
//  MainPageViewController.swift
//  Project_graduate
//
//  Created by 윤한솔 on 2023/01/04.
//

import UIKit
import SDWebImage
import Alamofire

class MainPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let images = ["a.jpeg","b.jpeg","c.jpeg","d.jpeg","e.jpeg"]
    var imageURLs : [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
//        tapGesture.delegate = self
//        self.view.addGestureRecognizer(tapGesture)
        // 클릭 된지 확인하기 위한 태그
        collectionView.tag = 1004
        //클릭 가능하도록 설정
        self.collectionView.isUserInteractionEnabled = true
        //제스쳐 추가
        self.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        fetchBookTitles { [weak self] imageUrl in
//            self?.imageURLs.append(imageUrl)
//            self?.collectionView.reloadData()
//        }
        //이미지 url userDefault로부터 가져옴
        imageURLs = ImageDataManager.shared.fetchAllSavedImageUrls()
        //확인용
        print(imageURLs)
        
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.indicator.isHidden = true
            self.indicator.stopAnimating()
        }
    }
    
    @objc func viewTapped(_ sender : UITapGestureRecognizer) {
        let location = sender.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            TitleManager.shared.Title = ImageDataManager.shared.fetchSavedTitle(at: indexPath.row)
        }
        print("\(sender.view!.tag) 클릭됨")
        print("\(TitleManager.shared.Title!) 책 호출")
        //결과 페이지로 넘어가는 함수
        self.navigationController?.pushViewController(resultVC(), animated: true)
    }
    
    //url 따오는 함수..
    func fetchBookTitles(completion: @escaping (String) -> Void) {
//        let url = "http://3.39.106.142:8080/book/info?bookTitle=세이노의 가르침"
        let url = "http://3.38.6.240:8080/book/info?bookTitle=%EC%84%B8%EC%9D%B4%EB%85%B8%EC%9D%98%20%EA%B0%80%EB%A5%B4%EC%B9%A8"
        //url -> fetchSavedImageUrl 이용하기
        
        AF.request(url).responseDecodable(of: BookTitleResponse.self) { (response) in
            switch response.result {
            case .success(let bookTitleResponse):
                let imageURL = bookTitleResponse.result.imageUrl
                completion(imageURL)
//                ImageDataManager.shared.saveImageUrl(imageURL) //이미지 url을 userdefault에 저장
                print("History success")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }


    @IBAction func onBtnCamera(_ sender: UIButton) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "CamViewController") as! CamViewController
        self.navigationController?.pushViewController(newVC, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    //-MARK
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return images.count
        return imageURLs.count
//        return 3
    }
      
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "BookCoverCollectionViewCell", for: indexPath) as! BookCoverCollectionViewCell
        
//        cell.BookCoverImage.image = UIImage(named: images[indexPath.row])
//        let url : URL = URL(string: "https://")!
//        cell.BookCoverImage.sd_setImage(with: url)
        //책 url 따와서 해보기
//        let imageUrl = imageURLs[indexPath.item]
        var imageUrl: String = ""

        if imageURLs.count > 0 {
            imageUrl = imageURLs[indexPath.item]
        } else {
            // 아무것도 하지 않음
        }

        cell.BookCoverImage.sd_setImage(with: URL(string: imageUrl), completed: nil)
        cell.BookCoverImage.layer.cornerRadius = 10
        cell.BookCoverImage.layer.cornerCurve = .continuous
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10 // 세로 간격
        }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 20 // 가로 간격
    }
}
