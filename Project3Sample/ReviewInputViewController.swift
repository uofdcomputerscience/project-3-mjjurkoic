//
//  ReviewInputViewController.swift
//  Project3Sample
//
//  Created by Russell Mirabelli on 11/16/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import UIKit

class ReviewInputViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var bodyField: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var bookID: Int?
    var canSubmit: Bool {
        if nameField.hasText && titleField.hasText && bodyField.hasText {
            return true
        }
        return false
    }
    var review: Review?
    let reviewService = ReviewService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if canSubmit {
            self.review = Review(id: nil, bookId: self.bookID!, date: nil, reviewer: self.nameField.text!, title: self.titleField.text!, body: self.bodyField.text)
            reviewService.createReview(review: self.review!) { () in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}
