//
//  ReviewListViewController.swift
//  Project3Sample
//
//  Created by Michael Jurkoic on 12/3/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import UIKit

class ReviewListViewController: UIViewController {
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
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
            DispatchQueue.main.async {
                self.reviewTableView.reloadData()
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchReviews()
    }
    
}

extension ReviewListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.configure(review: reviews[indexPath.row])
        return cell
    }
    
}

extension ReviewListViewController: UITableViewDelegate {
    
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
