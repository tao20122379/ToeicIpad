//
//  TestManager.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/27/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class TestManager: NSObject {
    
    class internal func getTests(book_id: Int?) -> Array<TestBook> {
        do {
            let realm = try Realm()
            
            var tests = realm.objects(TestBook.self)
            if ((book_id) != nil) {
                tests = realm.objects(TestBook.self).filter(String(format: "book_id=%i", book_id!))
            }
            return Array(tests)
        } catch let error as NSError {
            print(error)
            return Array()
        }


        
    }
    
    
    class func getTest(test_id: Int) -> TestBook {
        let realm = try! Realm()
        let test = realm.objects(TestBook.self).filter(String(format: "test_id=%i", test_id)).first
        return test!
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

class TestBook: Object {
    @objc dynamic var test_id = 0
    @objc dynamic var book_id = 0
    @objc dynamic var test_name = ""
    
    override static func primaryKey() -> String? {
        return "test_id"
    }
}


