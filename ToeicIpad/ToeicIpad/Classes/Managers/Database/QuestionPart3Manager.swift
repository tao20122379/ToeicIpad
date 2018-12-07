//
//  QuestionPart3Manager.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/7/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class QuestionPart3Manager: NSObject {
    
    class internal func getPart3TestPassage(test_id: Int?) -> Array<PassagePart3> {
        do {
            let realm = try Realm()
            var passages = realm.objects(PassagePart3.self)
            if ((test_id) != nil) {
                passages = realm.objects(PassagePart3.self).filter(String(format: "test_id=%i", test_id!))
            }
            return Array(passages)
        } catch let error as NSError {
            print(error)
            return Array()
        }
    }
    
    class internal func getPart3Questions(passage_id: Int?) -> Array<QuestionPart3> {
        do {
            let realm = try Realm()
            var tests = realm.objects(QuestionPart3.self)
            if ((passage_id) != nil) {
                tests = realm.objects(QuestionPart3.self).filter(String(format: "passage_id=%i", passage_id!))
            }
            return Array(tests)
        } catch let error as NSError {
            print(error)
            return Array()
        }
    }
    
    class func getPart3Passages(passage_id: Int) -> PassagePart3 {
        let realm = try! Realm()
        let passage = realm.objects(PassagePart3.self).filter(String(format: "passage_id=%i", passage_id)).first
        return passage!
    }
    
    
    class internal func addPart3Question(data: NSDictionary) -> Swift.Void {
        let question3 = QuestionPart3()
        question3.id = data["id"] as! Int
        question3.passage_id = data["passage_id"] as! Int
        question3.question = data["question"] as! String
        question3.answerA = data["answerA"] as! String
        question3.answerB = data["answerB"] as! String
        question3.answerC = data["answerC"] as! String
        question3.answerD = data["answerD"] as! String
        question3.answer_true = data["answer_true"] as! Int
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(question3, update: true);
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    class internal func addPart3Passage(data: NSDictionary) -> Swift.Void {
        let passage3 = PassagePart3()
        passage3.id = data["id"] as! Int
        passage3.test_id = data["test_id"] as! Int
        passage3.passage = data["passage"] as! String
        passage3.description_text = data["description_text"] as! String
        passage3.time_start = data["time_start"] as! Double
        passage3.time_end = data["time_end"] as! Double
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(passage3, update: true);
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
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
    override static func primaryKey() -> String? {
        return "id"
    }
}

class PassagePart3: Object {
    @objc dynamic var id = 0
    @objc dynamic var test_id = 0
    @objc dynamic var passage = ""
    @objc dynamic var time_start = 0.0
    @objc dynamic var time_end = 0.0
    @objc dynamic var description_text = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}
