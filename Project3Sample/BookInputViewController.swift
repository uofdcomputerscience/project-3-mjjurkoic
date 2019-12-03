//
//  BookInputViewController.swift
//  Project3Sample
//
//  Created by Russell Mirabelli on 11/16/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import UIKit

class BookInputViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var publicationDateField: UITextField!
    @IBOutlet weak var coverURLField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var canSubmit: Bool {
        if titleField.hasText && authorField.hasText && publicationDateField.hasText && coverURLField.hasText {
            return true
        }
        return false
    }
    var book: Book?
    let bookService = BookService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if canSubmit {
            book = Book(id: nil, title: titleField.text!, author: authorField.text!, published: publicationDateField.text!, imageURLString: coverURLField.text)
            bookService.createBook(book: book!) { () in
                DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}
