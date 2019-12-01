//
//  DataTestViewController.swift
//  Project3Sample
//
//  Created by Russell Mirabelli on 11/16/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import UIKit

// YOU MUST NOT SUBMIT THIS VIEW CONTROLLER WITH YOUR PROJECT

class DataTestViewController: UIViewController {
    
    @IBOutlet var coverImgeView: UIImageView!
    let bookService = BookService.shared
    let reviewService = ReviewService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBooks()
        fetchReviews()
        submitBook()
        submitReview()
    }
    
    func fetchBooks() {
        bookService.fetchBooks { [weak self] in
            print(String(describing: self?.bookService.books))
            self?.setImage()
        }
    }
    
    func fetchReviews() {
        reviewService.fetchReviews { [weak self] in
            print(String(describing: self?.reviewService.reviews))
        }
    }
    
    func submitBook() {
        let book = Book(id: nil, title: "A Tale of Two Cities", author: "Charles Dickens", published: "1859", imageURLString: "https://upload.wikimedia.org/wikipedia/commons/3/3c/Tales_serial.jpg")
        bookService.createBook(book: book) {
            print("book created")
        }
    }
    
    func submitReview() {
        let review = Review(id: nil, bookId: 1, date: Date(), reviewer: "Russell", title: "From a sample", body: "This is a review created from my sample app...")
        reviewService.createReview(review: review) {
            print("review created")
        }
    }
    
    func setImage() {
        let book = bookService.books.first!
        bookService.image(for: book) { [weak self] (retrievedBook, image) in
            if book.id == retrievedBook.id {
                DispatchQueue.main.async {
                    self?.coverImgeView.image = image
                }
            }
        }
    }
    
}
