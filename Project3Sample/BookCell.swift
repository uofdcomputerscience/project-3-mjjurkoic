//
//  BookCell.swift
//  Project3Sample
//
//  Created by Michael Jurkoic on 11/30/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    
    func configure(item: Book, service: BookService) {
        bookTitle.text = item.title
        bookAuthor.text = item.author
        service.image(for: item) { (book, image) in
            if item.imageURL == book.imageURL {
                DispatchQueue.main.async {
                    self.bookImage.image = image
                }
            }
        }
    }
}
