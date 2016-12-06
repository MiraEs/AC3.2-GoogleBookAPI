//
//  Book.swift
//  GoogleBookAPI
//
//  Created by Ilmira Estil on 12/4/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal enum JsonSerialization: Error {
    case bookJson(jsonData: Any)
    case itemsArr(bookJson: [String: AnyObject])
}
internal enum Parsing: Error {
    case id(itemDict: [String : AnyObject])
    case volumeInfo(itemArr: [[String : AnyObject]])
    case authors(volumeInfo: [String : AnyObject])
    case published(volumeInfo: [String : AnyObject])
    case images(volumeInfo: [String : AnyObject])
}

class Book {
    internal let id: String
    internal let title: String
    internal let authors: [String]
    internal let publishedDate: String
    internal let description: String
    internal let thumbnail: String?
    
    init(id: String, title: String, authors: [String], publishedDate: String, description: String, thumbnail: String) {
        self.id = id
        self.title = title
        self.authors = authors
        self.publishedDate = publishedDate
        self.description = description
        self.thumbnail = thumbnail
    }
    
    static func buildBook(from data: Data) -> [Book]? {
        var bookArr = [Book]()
        do {
            let json: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let bookJson = json as? [String: AnyObject] else {
                throw JsonSerialization.bookJson(jsonData: json)
            }
            
            guard let itemsArr = bookJson["items"] as? [[String: AnyObject]] else {
                throw JsonSerialization.itemsArr(bookJson: bookJson)
            }
            
            for itemDict in itemsArr {
                guard let id = itemDict["id"] as? String else {
                    throw Parsing.id(itemDict: itemDict)
                }
                
                guard let volumeInfoDict = itemDict["volumeInfo"] as? [String: AnyObject],
                    let title = volumeInfoDict["title"] as? String  else {
                        throw Parsing.volumeInfo(itemArr: itemsArr)
                }
                
                guard let authors = volumeInfoDict["authors"] as? [String] else {
                    throw Parsing.authors(volumeInfo: volumeInfoDict)
                }
                
                guard let publishedDate = volumeInfoDict["publishedDate"] as? String,
                    let description = volumeInfoDict["description"] as? String else {
                        throw Parsing.published(volumeInfo: volumeInfoDict)
                }
                guard let imageLinks = volumeInfoDict["imageLinks"] as? [String: AnyObject],
                    let thumbnail = imageLinks["smallThumbnail"] as? String else {
                        throw Parsing.images(volumeInfo: volumeInfoDict)
                }
                
                let bookProperties = Book.init(id: id, title: title, authors: authors, publishedDate: publishedDate, description: description, thumbnail: thumbnail)
                bookArr.append(bookProperties)
            }
        } catch let JsonSerialization.bookJson(jsonData: json) {
            print("Error jsonData: \(json)")
        } catch let JsonSerialization.itemsArr(bookJson: bookJson) {
            print("Error bookJson: \(bookJson)")
        } catch let Parsing.id(itemDict: itemDict) {
            print("Error id: \(itemDict)")
        }
        catch let Parsing.volumeInfo(itemArr: itemsArr) {
            print("Error volumeInfo: \(itemsArr)")
        } catch let Parsing.authors(volumeInfo: volumeInfoDict) {
            print("Error authors: \(volumeInfoDict)")
        } catch let Parsing.published(volumeInfo: volumeInfoDict) {
            print("Error published: \(volumeInfoDict)")
        } catch let Parsing.images(volumeInfo: volumeInfoDict) {
            print("Error images: \(volumeInfoDict)")
        } catch {
            print(error)
        }
        return bookArr
    }
}
