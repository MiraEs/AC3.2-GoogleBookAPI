//
//  APIManager.swift
//  GoogleBookAPI
//
//  Created by Ilmira Estil on 12/4/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class APIManager {
    static let manager = APIManager()
    private init() {}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> () ) {
        guard let url = URL(string: endPoint) else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error getting data")
            }
            guard let validData = data else { return }
            callback(validData)
        }.resume()
    }
}
