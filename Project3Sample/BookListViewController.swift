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
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var addBookButton: UIButton!
    
    var books: [Book] = []
    let bookService = BookService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBooks()
        bookTableView.dataSource = self
        bookTableView.delegate = self
        
    }
    
    func fetchBooks() {
        bookService.fetchBooks{ () in
            self.books = self.bookService.books
            DispatchQueue.main.async {
                self.bookTableView.reloadData()
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchBooks()
    }
    
    @IBAction func addBookButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let bookInputView = storyboard?.instantiateViewController(identifier: "BookInputView") as! BookInputViewController
            navigationController?.pushViewController(bookInputView, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    
}

extension BookListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bookTableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.configure(item: books[indexPath.row], service: bookService)
        return cell
    }
    
}

extension BookListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = books[indexPath.item]
        if #available(iOS 13.0, *) {
            let detail = storyboard?.instantiateViewController(identifier: "BookDetailView") as! BookDetailViewController
            self.bookService.image(for: selectedBook) { (book, image) in
                if selectedBook.imageURL == book.imageURL {
                    DispatchQueue.main.async {
                        detail.bookImage?.image = image
                    }
                }
                DispatchQueue.main.async {
                    detail.bookTitle?.text = selectedBook.title
                    detail.bookAuthor?.text = selectedBook.author
                    detail.bookPublication?.text = selectedBook.published
                    detail.bookID = selectedBook.id
                }
            }
            navigationController?.pushViewController(detail, animated: true)
        } else {
            // TODO: Add fallback for earlier iOS versions
        }
    }
    
}
