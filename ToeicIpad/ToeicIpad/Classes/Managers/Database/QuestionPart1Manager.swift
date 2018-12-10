//
//  QuestionPart1Manager.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/15/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class QuestionPart1Manager: NSObject {
    
    class internal func getListQuestion1(test_id: Int?) -> Array<QuestionPart1> {
        do {
            let realm = try Realm()
            var tests = realm.objects(QuestionPart1.self)
            if ((test_id) != nil && tests.count > 0) {
                tests = realm.objects(QuestionPart1.self).filter(String(format: "test_id=%i", test_id!))
            }
            return Array(tests)
        } catch let error as NSError {
            print(error)
            return Array()
        }

    }
    
    
    class func getQuestion1(question_id: Int) -> QuestionPart1 {
        let realm = try! Realm()
        let test = realm.objects(QuestionPart1.self).filter(String(format: "id=%i", question_id)).first
        return test!
    }
    
    class internal func addQuestion1(data: NSDictionary) -> Swift.Void {
        let question1 = QuestionPart1()
        question1.id = data["id"] as! Int
        question1.test_id = data["test_id"] as! Int
        question1.image_url = data["image_url"] as! String
        question1.answerA = data["answerA"] as! String
        question1.answerB = data["answerB"] as! String
        question1.answerC = data["answerC"] as! String
        question1.answerD = data["answerD"] as! String
        question1.answer_true = data["answer_true"] as! Int
        question1.time_start = data["time_start"] as! Double
        question1.time_end = data["time_end"] as! Double
        question1.description_text = data["description_text"] as! String
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(question1, update: true);
            }
        } catch let error as NSError {
            print(error)
        }
    }
}

class QuestionPart1: Object {
    @objc dynamic var id = 0
    @objc dynamic var test_id = 0
    @objc dynamic var image_url = ""
    @objc dynamic var answerA = ""
    @objc dynamic var answerB = ""
    @objc dynamic var answerC = ""
    @objc dynamic var answerD = ""
    @objc dynamic var answer_true = 0
    @objc dynamic var time_start = 0.0
    @objc dynamic var time_end = 0.0
    @objc dynamic var description_text = ""
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
