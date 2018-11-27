

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




class QuestionPart2: Object {
    @objc dynamic var id = 0
    @objc dynamic var question = 0
    @objc dynamic var image_url = ""
    @objc dynamic var answerA = ""
    @objc dynamic var answerB = ""
    @objc dynamic var answerC = ""
    @objc dynamic var answer_true = ""
    @objc dynamic var time_start = 0.0
    @objc dynamic var time_end = 0.0
    @objc dynamic var descriptionText = ""
}

class QuestionPart3: Object {
    @objc dynamic var id = 0
    @objc dynamic var passage_id = 0
    @objc dynamic var question = ""
    @objc dynamic var answerA = ""
    @objc dynamic var answerB = ""
    @objc dynamic var answerC = ""
    @objc dynamic var answerD = ""
    @objc dynamic var answer_true = 0
    @objc dynamic var descriptionText = ""
}

class QuestionPart4: Object {
    @objc dynamic var id = 0
    @objc dynamic var passage_id = 0
    @objc dynamic var question = ""
    @objc dynamic var answerA = ""
    @objc dynamic var answerB = ""
    @objc dynamic var answerC = ""
    @objc dynamic var answerD = ""
    @objc dynamic var answer_true = 0
    @objc dynamic var descriptionText = ""
}

class PassagePart3: Object {
    @objc dynamic var id = 0
    @objc dynamic var test_id = 0
    @objc dynamic var passage = ""
    @objc dynamic var pass_description = ""
    @objc dynamic var time_start = 0.0
    @objc dynamic var time_end = 0.0
}

class PassagePart4: Object {
    @objc dynamic var id = 0
    @objc dynamic var test_id = 0
    @objc dynamic var passage = ""
    @objc dynamic var pass_description = ""
    @objc dynamic var time_start = 0.0
    @objc dynamic var time_end = 0.0
}

//class QuestionPart5: Object {
//    @objc dynamic var id = 0
//    @objc dynamic var test_id = 0
//    @objc dynamic var question = ""
//    @objc dynamic var answerA = ""
//    @objc dynamic var answerB = ""
//    @objc dynamic var answerC = ""
//    @objc dynamic var answerD = ""
//    @objc dynamic var answer_true = 0
//}
//
//
//class QuestionPart6: Object {
//    @objc dynamic var id = 0
//    @objc dynamic var passage_id = 0
//    @objc dynamic var image_url = ""
//    @objc dynamic var answerA = ""
//    @objc dynamic var answerB = ""
//    @objc dynamic var answerC = ""
//    @objc dynamic var answerD = ""
//    @objc dynamic var answer_true = 0
//}
//
//class QuestionPart7: Object {
//    @objc dynamic var id = 0
//    @objc dynamic var passage_id = 0
//    @objc dynamic var image_url = ""
//    @objc dynamic var answerA = ""
//    @objc dynamic var answerB = ""
//    @objc dynamic var answerC = ""
//    @objc dynamic var answerD = ""
//    @objc dynamic var answer_true = 0
//}



//class PassagePart6: Object {
//    @objc dynamic var id = 0
//    @objc dynamic var test_id = 0
//    @objc dynamic var passage = ""
//    @objc dynamic var pass_description = ""
//    @objc dynamic var time_start = 0.0
//    @objc dynamic var time_end = 0.0
//}
//
//class PassagePart7: Object {
//    @objc dynamic var id = 0
//    @objc dynamic var test_id = 0
//    @objc dynamic var passage1 = ""
//    @objc dynamic var passage2 = ""
//    @objc dynamic var pass_description1 = ""
//    @objc dynamic var pass_description2 = ""
//    @objc dynamic var time_start = 0.0
//    @objc dynamic var time_end = 0.0
//}
