//
//  QuestionPart4Manager.swift
//  ToeicIpad
//
//  Created by DungLM4 on 12/7/18.
//  Copyright © 2018 DungLM4. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class QuestionPart4Manager: NSObject {
    class internal func getPart4TestPassage(test_id: Int?) -> Array<PassagePart4> {
        do {
            let realm = try Realm()
            var passages = realm.objects(PassagePart4.self)
            if ((test_id) != nil && passages.count > 0) {
                passages = realm.objects(PassagePart4.self).filter(String(format: "test_id=%i", test_id!))
            }
            return Array(passages)
        } catch let error as NSError {
            print(error)
            return Array()
        }
    }
    
    class internal func getPart4Questions(passage_id: Int?) -> Array<QuestionPart4> {
        do {
            let realm = try Realm()
            var tests = realm.objects(QuestionPart4.self)
            if ((passage_id) != nil) {
                tests = realm.objects(QuestionPart4.self).filter(String(format: "passage_id=%i", passage_id!))
            }
            return Array(tests)
        } catch let error as NSError {
            print(error)
            return Array()
        }
    }
    
    class func getPart4Passages(passage_id: Int) -> PassagePart4 {
        let realm = try! Realm()
        let passage = realm.objects(PassagePart4.self).filter(String(format: "id=%i", passage_id)).first
        return passage!
    }
    
    
    class internal func addPart4Question(data: NSDictionary) -> Swift.Void {
        let question4 = QuestionPart4()
        question4.initWithDatas(data: data)
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(question4, update: true);
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    class internal func addPart4Passage(data: NSDictionary) -> Swift.Void {
        let passage4 = PassagePart4()
        passage4.initWithDatas(data: data)
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(passage4, update: true);
            }
        } catch let error as NSError {
            print(error)
        }
    }
}

class QuestionPart4: Object {
    @objc dynamic var id = 0
    @objc dynamic var test_id = 0
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
    
    func initWithDatas(data: NSDictionary) -> Void {
        id = data["id"] as! Int
        test_id = data["test_id"] as! Int
        passage_id = data["passage_id"] as! Int
        question = data["question"] as! String
        answerA = data["answerA"] as! String
        answerB = data["answerB"] as! String
        answerC = data["answerC"] as! String
        answerD = data["answerD"] as! String
        answer_true = data["answer_true"] as! Int
    }
}


class PassagePart4: Object {
    @objc dynamic var id = 0
    @objc dynamic var test_id = 0
    @objc dynamic var passage = ""
    @objc dynamic var time_start = 0.0
    @objc dynamic var time_end = 0.0
    @objc dynamic var description_text = ""
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func initWithDatas(data: NSDictionary) -> Void {
        id = data["id"] as! Int
        test_id = data["test_id"] as! Int
        passage = data["passage"] as! String
        description_text = data["description_text"] as! String
        time_start = data["time_start"] as! Double
        time_end = data["time_end"] as! Double
    }
}
