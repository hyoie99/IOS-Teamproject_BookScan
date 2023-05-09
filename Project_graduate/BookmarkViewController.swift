//
//  bookmarkVC.swift
//  api3
//
//  Created by 이혜인 on 2023/05/08.
//

import UIKit

class bookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let bookmarkArray = BookMarkData.shared.bookmarkArray
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("bookmarkVC called")
        
        for key in bookmarkArray {
            if let curBook = UserDefaults.standard.object(forKey: key) as? [String: Any] {
                if let urlString = curBook["image"] as? String, let titleString = curBook["title"] as? String, let authorString = curBook["author"] as? String {
                    let book = Book(imageUrl: urlString, title: titleString, author: authorString)
                    books.append(book)
                }
            }
        }
        
        print(books.count)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        books.removeAll() // 기존에 추가된 책 데이터를 모두 제거
        for key in bookmarkArray {
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

        if let urlString = book.imageUrl as? String, let url = URL(string: urlString) {
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

// Book 모델
struct Book {
    let imageUrl: String
    let title: String
    let author: String
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
