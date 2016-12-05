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
    @IBOutlet weak var detailBookDescription: UITextView!
    @IBOutlet weak var detailBookAuthor: UILabel!
    @IBOutlet weak var detailBookTitle: UILabel!
    @IBOutlet weak var detailBookImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailBookTitle.text = detailBook?.title
    }


}

