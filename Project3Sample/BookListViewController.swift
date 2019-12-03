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
    @IBOutlet weak var listViewToggle: UISegmentedControl!
    @IBOutlet weak var booksView: UIView!
    @IBOutlet weak var reviewTableView: UITableView!
    
    var books: [Book] = []
    var reviews: [Review] = []
    let bookService = BookService()
    let reviewService = ReviewService()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        booksView.isHidden = false
        reviewTableView.isHidden = true
        fetchBooks()
        fetchReviews()
        bookTableView.dataSource = self
        bookTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
    }
    
    func fetchBooks() {
        bookService.fetchBooks{ () in
            self.books = self.bookService.books
            DispatchQueue.main.async {
                self.bookTableView.reloadData()
            }
        }
    }
    
    func fetchReviews() {
        reviewService.fetchReviews { () in
            self.reviews = self.reviewService.reviews
            DispatchQueue.main.async {
                self.reviewTableView.reloadData()
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
    
    @IBAction func listViewToggleChanged(_ sender: Any) {
        if listViewToggle.selectedSegmentIndex == 0 {
            booksView.isHidden = false
            reviewTableView.isHidden = true
            DispatchQueue.main.async {
                self.bookTableView.reloadData()
            }
        } else if listViewToggle.selectedSegmentIndex == 1 {
            booksView.isHidden = true
            reviewTableView.isHidden = false
            DispatchQueue.main.async {
                self.reviewTableView.reloadData()
            }
        }
    }
    
}

extension BookListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviewTableView.isHidden {
            return books.count
        }
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if reviewTableView.isHidden {
            let cell = bookTableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
            cell.configure(item: books[indexPath.row], service: bookService)
            return cell
        }
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.configure(review: reviews[indexPath.row])
        return cell
    }
    
}

extension BookListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if reviewTableView.isHidden {
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
        let selectedReview = reviews[indexPath.item]
        if #available(iOS 13.0, *) {
            let detail = storyboard?.instantiateViewController(identifier: "ReviewDetailView") as! ReviewDetailViewController
            DispatchQueue.main.async {
                detail.reviewTitle?.text = selectedReview.title
                detail.reviewAuthor?.text = selectedReview.reviewer
                self.formatter.dateFormat = "EEEE, d MMM, yyyy"
                detail.reviewDate?.text = self.formatter.string(from: selectedReview.date ?? Date())
                detail.reviewBody?.text = selectedReview.body
            }
            navigationController?.pushViewController(detail, animated: true)
        } else {
            // TODO: Add fallback for earlier iOS versions
        }
    }
    
}
