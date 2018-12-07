//
//  BookManager.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/27/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import RealmSwift

class BookManager: NSObject {
    
    class internal func getBooks() -> Array<Book> {
        let realm = try! Realm()
        let books = realm.objects(Book.self)
        return Array(books)
    }
    
    
    class func getBook(book_id: Int) -> Book {
        let realm = try! Realm()
        let book = realm.objects(Book.self).filter(String(format: "book_id=%i", book_id)).first
        return book!
    }
    
    class internal func addBook(bookData: NSDictionary) -> Swift.Void {
        let book = Book()
        book.book_id = bookData["book_id"] as! Int
        book.book_name = bookData["book_name"] as! String
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(book, update: true);
            }
        } catch let error as NSError {
            print(error)
        }
    }


}


