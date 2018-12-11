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
    
    class internal func getAllTests() -> Array<TestBook> {
        do {
            let realm = try Realm()
            
            let tests = realm.objects(TestBook.self).sorted(byKeyPath: "test_id")
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
    
    class func updateDataTest(test: TestBook, part: Int) -> Void {
            do {
                let realm = try Realm()
                try realm.write {
                    switch part {
                    case 1:
                        test.isDataPart1 = true
                        break
                    case 2:
                        test.isDataPart2 = true
                        break
                    case 3:
                        test.isDataPart3 = true
                        break
                    case 4:
                        test.isDataPart4 = true
                        break
                    default:
                        break
                    }
            
                }

            } catch let error as NSError {
                print(error)
            }
     
    
    }
    
    class internal func addTest(testData: NSDictionary) -> Swift.Void {
        let testBook = TestBook()
        testBook.book_id = testData["book_id"] as! Int 
        testBook.test_id = testData["test_id"] as! Int
        testBook.test_name = testData["test_name"] as! String

        do {
            let realm = try Realm()
            let part1Data = realm.objects(QuestionPart1.self).filter(String(format: "test_id=%i", testBook.test_id))
            let part2Data = realm.objects(QuestionPart2.self).filter(String(format: "test_id=%i", testBook.test_id))
            let part3Data = realm.objects(PassagePart3.self).filter(String(format: "test_id=%i", testBook.test_id))
            let part4Data = realm.objects(PassagePart4.self).filter(String(format: "test_id=%i", testBook.test_id))
            if (part1Data.count > 0) {
                testBook.isDataPart1 = true
            }
            if (part2Data.count > 0) {
                testBook.isDataPart2 = true
            }
            if (part3Data.count > 0) {
                testBook.isDataPart3 = true
            }
            if (part4Data.count > 0) {
                testBook.isDataPart4 = true
            }
            
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
    @objc dynamic var isDataPart1 = false
    @objc dynamic var isDataPart2 = false
    @objc dynamic var isDataPart3 = false
    @objc dynamic var isDataPart4 = false
    
    override static func primaryKey() -> String? {
        return "test_id"
    }
}


