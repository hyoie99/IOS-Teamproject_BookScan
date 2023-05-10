//
//  bookmarkVC.swift
//  api3
//
//  Created by 이혜인 on 2023/05/08.
//

import UIKit

class bookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let bookmarkShared = BookMarkData.shared
    var books: [Book] = []
    
    
    @IBAction func tapSetting(_ sender: UIButton) {
        print("pushed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let settingVC = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController {
            self.navigationController?.pushViewController(settingVC, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("bookmarkVC called")
        for key in bookmarkShared.bookmarkArray {
            if let curBook = UserDefaults.standard.object(forKey: key) as? [String: Any] {
                print(curBook)
                if let urlString = curBook["image"] as? String, let titleString = curBook["title"] as? String, let authorString = curBook["author"] as? String {
                    print(urlString, titleString, authorString)
                    let book = Book(imageUrl: urlString, title: titleString, author: authorString)
                    books.append(book)
                }
            }
        }
        
        print("bookmarkview: \(books.count)")
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        books.removeAll() // 기존에 추가된 책 데이터를 모두 제거
        for key in bookmarkShared.bookmarkArray {
            if let curBook = UserDefaults.standard.object(forKey: key) as? [String: Any] {
                if let urlString = curBook["image"] as? String, let titleString = curBook["title"] as? String, let authorString = curBook["author"] as? String {
                    let book = Book(imageUrl: urlString, title: titleString, author: authorString)
                    books.append(book)
                }
            }
        }
        tableView.reloadData() // 테이블 뷰 리로드
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        let book = books[indexPath.row]

        if let url = URL(string: book.imageUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    cell.bookImageView.image = image
                    tableView.reloadData()
                }
            }.resume()
        }
        cell.bookNameLabel.text = book.title
        cell.authorNameLabel.text = book.author

        return cell
    }
}


// BookTableViewCell
class BookTableViewCell: UITableViewCell {
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UITextView!
    @IBOutlet weak var authorNameLabel: UITextView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
