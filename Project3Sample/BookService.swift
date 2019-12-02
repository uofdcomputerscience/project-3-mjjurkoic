//
//  BookService.swift
//  Project3Sample
//
//  Created by Russell Mirabelli on 11/16/19.
//  Copyright © 2019 Russell Mirabelli. All rights reserved.
//

import UIKit

class BookService {
    var books: [Book] = []
    private var bookImages: [URL: UIImage] = [:]
    
    let url = URL(string: "https://uofd-tldrserver-develop.vapor.cloud/books")!

    static var shared: BookService = BookService()
    
    func fetchBooks(completion: @escaping () -> Void) {
        let task = URLSession(configuration: .ephemeral).dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                if let newBooks = try? JSONDecoder().decode([Book].self, from: data) {
                    self?.books = newBooks
                    completion()
                }
            }
        }
        task.resume()
    }
    
    func createBook(book: Book, completion: @escaping () -> Void) {
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(book) else { return }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = body
        let task = URLSession(configuration: .ephemeral).dataTask(with: request) { (data, response, error) in
            completion()
        }
        task.resume()
    }
    
    func image(for book: Book, completion: @escaping (Book, UIImage?) -> Void) {
        guard let imageURL = book.imageURL else { completion(book, nil); return }
        if bookImages[imageURL] != nil { completion(book, bookImages[imageURL]); return }
        let task = URLSession(configuration: .default).dataTask(with: imageURL) { [weak self] (data, response, error) in
            guard let data = data else { completion(book, nil); return }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.bookImages[imageURL] = image
                    completion(book, image)
                }
            } else {
                completion(book, nil)
            }
        }
        task.resume()
    }
    
}
