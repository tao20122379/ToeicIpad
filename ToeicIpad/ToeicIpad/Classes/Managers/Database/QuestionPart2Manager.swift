//
//  QuestionPart2Manager.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/7/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class QuestionPart2Manager: NSObject {
    class internal func getListQuestion2(test_id: Int?) -> Array<QuestionPart2> {
        do {
            let realm = try Realm()
            var tests = realm.objects(QuestionPart2.self)
            if ((test_id) != nil && tests.count > 0) {
                tests = realm.objects(QuestionPart2.self).filter(String(format: "test_id=%i", test_id!))
            }
            return Array(tests)
        } catch let error as NSError {
            print(error)
            return Array()
        }
        
    }
    
    
    class func getQuestion2(question_id: Int) -> QuestionPart2 {
        let realm = try! Realm()
        let test = realm.objects(QuestionPart2.self).filter(String(format: "id=%i", question_id)).first
        return test!
    }
    
    class internal func addQuestion2(data: NSDictionary) -> Swift.Void {
        let question2 = QuestionPart2()
        question2.initWithDatas(data: data)
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(question2, update: true);
            }
        } catch let error as NSError {
            print(error)
        }
    }
}



class QuestionPart2: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var test_id = 0
    @objc dynamic var question = ""
    @objc dynamic var answerA = ""
    @objc dynamic var answerB = ""
    @objc dynamic var answerC = ""
    @objc dynamic var answer_true = 0
    @objc dynamic var time_start = 0.0
    @objc dynamic var time_end = 0.0
    @objc dynamic var description_text = ""
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func initWithDatas(data: NSDictionary) -> Void {
        id = data["id"] as! Int
        test_id = data["test_id"] as! Int
        question = data["question"] as! String
        answerA = data["answerA"] as! String
        answerB = data["answerB"] as! String
        answer_true = data["answer_true"] as! Int
        answerC = data["answerC"] as! String
        time_start = data["time_start"] as! Double
        time_end = data["time_end"] as! Double
        description_text = data["description_text"] as! String
    }
}
