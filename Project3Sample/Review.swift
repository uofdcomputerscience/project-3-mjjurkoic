//
//  Review.swift
//  Project3Sample
//
//  Created by Russell Mirabelli on 11/16/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import Foundation

struct Review: Codable {
    let id: Int?
    let bookId: Int
    let date: Date?
    let reviewer: String
    let title: String
    let body: String
}
