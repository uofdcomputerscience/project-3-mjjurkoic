//
//  BookListViewController.swift
//  Project3Sample
//
//  Created by Russell Mirabelli on 11/16/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import UIKit

class BookListViewController: UIViewController {
    
    @IBOutlet weak var bookTableView: UITableView!
    
    var books: [Book] = []
    var bookImages = Dictionary<String, UIImage>()
    let bookService = BookService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookService.fetchBooks{ [weak self] () in
            DispatchQueue.main.async {
                self?.bookTableView.reloadData()
            }
        }
        bookTableView.dataSource = self
        bookTableView.delegate = self
    }
    
}

extension BookListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bookTableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.configure(item: books[indexPath.row], service: bookService, parentViewController: self)
        return cell
    }
    
}

extension BookListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
