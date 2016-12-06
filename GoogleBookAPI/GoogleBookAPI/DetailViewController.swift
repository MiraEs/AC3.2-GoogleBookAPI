//
//  ViewController.swift
//  GoogleBookAPI
//
//  Created by Ilmira Estil on 12/4/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var detailBook: Book?
    let volumeEndpoint = "https://www.googleapis.com/books/v1/volumes/"
    
    
    @IBOutlet weak var detailBookDescription: UITextView!
    @IBOutlet weak var detailBookAuthor: UILabel!
    @IBOutlet weak var detailBookTitle: UILabel!
    @IBOutlet weak var detailBookImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailBookTitle.text = detailBook?.title
        detailBookDescription.text = detailBook?.description
        detailBookAuthor.text = allAuthors()
        image()
    }
    
    
    func allAuthors() -> String {
        var authors = ""
        for author in (detailBook?.authors)! {
            authors += String("\(author)")
        }
        return authors
    }
    
    func image() {
        if detailBook?.thumbnail != nil {
            APIManager.manager.getData(endPoint: (detailBook?.thumbnail)!, callback: { (data: Data?) in
                guard let validData = data else { return }
                DispatchQueue.main.async {
                    self.detailBookImage.image = UIImage(data: validData)
                    self.detailBookImage.setNeedsLayout()
                }
            })
        }
    }
    
    
}

