//
//  BookDetailViewController.swift
//  Project3Sample
//
//  Created by Russell Mirabelli on 11/16/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookPublication: UILabel!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var reviewButton: UIButton!
    
    var bookID: Int?
    
    var reviews: [Review] = []
    let reviewService = ReviewService()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchReviews()
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
    }
    
    func fetchReviews() {
        reviewService.fetchReviews { () in
            self.reviews = self.reviewService.reviews
            self.reviews = self.reviews.filter { (someReview) -> Bool in
                someReview.id == self.bookID
            }
            DispatchQueue.main.async {
                self.reviewTableView.reloadData()
            }
        }
    }
    
    @IBAction func reviewButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let reviewInputView = storyboard?.instantiateViewController(identifier: "ReviewInputView") as! ReviewInputViewController
            reviewInputView.bookID = self.bookID
            navigationController?.pushViewController(reviewInputView, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchReviews()
    }
    
}

extension BookDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.configure(review: reviews[indexPath.row])
        return cell
    }
    
}

extension BookDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
