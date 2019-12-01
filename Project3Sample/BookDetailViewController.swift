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
    
    var reviews: [Review] = []
    let reviewService = ReviewService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewService.fetchReviews { [weak self] in
            DispatchQueue.main.async {
                self?.reviewTableView.reloadData()
            }
        }
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
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
    
}
