

//
//  DatabaseManager.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/22/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class DatabaseManager: NSObject {
    
    class internal func getTest() -> Array<TestBook> {
        let realm = try! Realm()
        let books = realm.objects(TestBook.self)
        return Array(books)
    }
    
    class internal func addTest(book_id: Int, test_id: Int, test_name: String) -> Swift.Void {
        let testBook = TestBook()
        testBook.book_id = book_id
        testBook.test_id = test_id
        testBook.test_name = test_name
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(testBook, update: true);
            }
        } catch let error as NSError {
            print(error)
        }
    }
}

class Book: Object {
    @objc dynamic var book_id = 0
    @objc dynamic var book_name = ""
    override static func primaryKey() -> String? {
        return "book_id"
    }
}
