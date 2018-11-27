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
    class internal func getQuestion1(test_id: Int?) -> Array<QuestionPart1> {
        do {
            let realm = try Realm()
            var tests = realm.objects(QuestionPart1.self)
            if ((test_id) != nil) {
                tests = realm.objects(QuestionPart1.self).filter(String(format: "test_id=%i", test_id!))
            }
            return Array(tests)
        } catch let error as NSError {
            print(error)
            return Array()
        }

    }
    
    
    class func getQuestion1(question_id: Int) -> TestBook {
        let realm = try! Realm()
        let test = realm.objects(TestBook.self).filter(String(format: "id=%i", question_id)).first
        return test!
    }
    
    class internal func addQuestion1(id: Int, test_id: Int, image_url: String, answerA: String, answerB: String, answerC: String, answerD: String, answer_true: String, time_start: Double, time_end: Double, descriptionText: String) -> Swift.Void {
        let question1 = QuestionPart1()
        question1.id = id
        question1.test_id = test_id
        question1.image_url = image_url
        question1.answerA = answerA
        question1.answerB = answerB
        question1.answerC = answerC
        question1.answerD = answerD
        question1.answer_true = answer_true
        question1.time_start = time_start
        question1.time_end = time_end
        question1.descriptionText = descriptionText
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
    @objc dynamic var answer_true = ""
    @objc dynamic var time_start = 0.0
    @objc dynamic var time_end = 0.0
    @objc dynamic var descriptionText = ""
}
