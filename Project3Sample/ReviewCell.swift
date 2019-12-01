//
//  ReviewListViewController.swift
//  Project3Sample
//
//  Created by Russell Mirabelli on 11/16/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var reviewTitle: UILabel!
    @IBOutlet weak var reviewAuthor: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var reviewText: UITextView!
    
    func configure(review: Review) {
        reviewTitle.text = review.title
        reviewAuthor.text = review.reviewer
        // TODO: Add date formatter
//        reviewDate.text = review.date.format()
        reviewText.text = review.body
    }
    
}
