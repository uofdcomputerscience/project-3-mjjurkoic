//
//  ReviewService.swift
//  Project3Sample
//
//  Created by Russell Mirabelli on 11/16/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import Foundation

class ReviewService {
    var reviews: [Review] = []
    
    let url = URL(string: "https://uofd-tldrserver-develop.vapor.cloud/reviews")!

    static var shared: ReviewService = ReviewService()
    
    func fetchReviews(completion: @escaping () -> Void) {
        let task = URLSession(configuration: .ephemeral).dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let newReviews = try? decoder.decode([Review].self, from: data) {
                    self?.reviews = newReviews
                    completion()
                }
            }
        }
        task.resume()
    }
    
    func createReview(review: Review, completion: @escaping () -> Void) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let body = try? encoder.encode(review) else { return }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = body
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) { (data, response, error) in
            completion()
        }
        task.resume()
    }
    
}
