//
//  BookTableViewController.swift
//  GoogleBookAPI
//
//  Created by Ilmira Estil on 12/4/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit


class BookTableViewController: UITableViewController {
    let endpoint = "https://www.googleapis.com/books/v1/volumes?q=banana"
    var bookObject: Book!
    var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    func getData() {
        APIManager.manager.getData(endPoint: endpoint) { (data: Data?) in
            if let validData = data,
                let validBook = Book.buildBook(from: validData) {
                self.books = validBook
                print(validBook)
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)
        
        // Configure the cell...
        if let bookCell = cell as? BookTableViewCell {
            let currentBook = books[indexPath.row]
            
            bookCell.bookTitle?.text = currentBook.title
            
            //image
            if currentBook.thumbnail != nil {
                APIManager.manager.getData(endPoint: currentBook.thumbnail!, callback: { (data: Data?) in
                    guard let validData = data else { return }
                    DispatchQueue.main.async {
                        bookCell.bookThumbnail?.image = UIImage(data: validData)
                        bookCell.setNeedsLayout()
                    }
                })
            }
        }
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? DetailViewController,
            let cell = sender as? BookTableViewCell,
            let indexpath = tableView.indexPath(for: cell) {
            dvc.detailBook = books[indexpath.row]
        }
        
    }
    
}
