//
//  QuestionCell.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/6/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import DLRadioButton
import Foundation

class QuestionCell: UITableViewCell {

    @IBOutlet weak var btnA: DLRadioButton!
    @IBOutlet weak var btnB: DLRadioButton!
    @IBOutlet weak var btnC: DLRadioButton!
    @IBOutlet weak var btnD: DLRadioButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerALabel: UILabel!
    @IBOutlet weak var answerBLabel: UILabel!
    @IBOutlet weak var answerCLabel: UILabel!
    @IBOutlet weak var answerDLabel: UILabel!
    var selectedIndex: Int?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        btnA.frame.size.height = answerALabel.frame.size.height + 10
        btnB.frame.size.height = answerBLabel.frame.size.height + 10
        btnC.frame.size.height = answerCLabel.frame.size.height + 10
        btnD.frame.size.height = answerDLabel.frame.size.height + 10
        btnA.tag = 1
        btnB.tag = 2
        btnC.tag = 3
        btnD.tag = 4
    }

    
    func showDataPart1(data: QuestionPart1) -> Void {
        answerALabel.text = String(format: "(A) %@", data.answerA)
        answerBLabel.text = String(format: "(B) %@", data.answerB)
        answerCLabel.text = String(format: "(C) %@", data.answerC)
        answerDLabel.text = String(format: "(D) %@", data.answerD)
    
        showAnswerTrueFalse(index: data.answer_true, isTrue: true)
        if (selectedIndex != nil) {
            if (!(data.answer_true == selectedIndex)) {
                showAnswerTrueFalse(index: selectedIndex!, isTrue: false)
            }
        }
      
    }
    
    func showDataPart2(data: QuestionPart2) -> Void {
        questionLabel.text = data.question
        answerALabel.text = String(format: "(A) %@", data.answerA)
        answerBLabel.text = String(format: "(B) %@", data.answerB)
        answerCLabel.text = String(format: "(C) %@", data.answerC)
        
        showAnswerTrueFalse(index: data.answer_true, isTrue: true)
        if (selectedIndex != nil) {
            if (!(data.answer_true == selectedIndex)) {
                showAnswerTrueFalse(index: selectedIndex!, isTrue: false)
            }
        }
        
    }
    
    func showDataPart3(data: QuestionPart3) -> Void {
        showAnswerTrueFalse(index: data.answer_true, isTrue: true)
        if (selectedIndex != nil) {
            if (!(data.answer_true == selectedIndex)) {
                showAnswerTrueFalse(index: selectedIndex!, isTrue: false)
            }
        }
        
    }
    
    func showDataPart4(data: QuestionPart4) -> Void {
        showAnswerTrueFalse(index: data.answer_true, isTrue: true)
        if (selectedIndex != nil) {
            if (!(data.answer_true == selectedIndex)) {
                showAnswerTrueFalse(index: selectedIndex!, isTrue: false)
            }
        }
        
    }
    
    
    func showAnswerTrueFalse(index: Int, isTrue: Bool) -> Void {
        var imageStr: String = "check_false"
        var colorHex: String = "ED2A00"
        if (isTrue) {
            imageStr = "check_true"
            colorHex = "4F8F00"
        }
        switch index {
        case 1:
            btnA.icon = UIImage(named: imageStr)!
            btnA.iconSelected = UIImage(named: imageStr)!
            answerALabel.textColor = Util.hexStringToUIColor(hex: colorHex)
            break
        case 2:
            btnB.icon = UIImage(named: imageStr)!
            btnB.iconSelected = UIImage(named: imageStr)!
            answerBLabel.textColor = Util.hexStringToUIColor(hex: colorHex)
            break
        case 3:
            btnC.icon = UIImage(named: imageStr)!
            btnC.iconSelected = UIImage(named: imageStr)!
            answerCLabel.textColor = Util.hexStringToUIColor(hex: colorHex)
            break
        case 4:
            btnD.icon = UIImage(named: imageStr)!
            btnD.iconSelected = UIImage(named: imageStr)!
            answerDLabel.textColor = Util.hexStringToUIColor(hex: colorHex)
            break
        default:
            break
        }
    }
    
    @IBAction func btnAnswerSelected(_ sender: UIButton) {
        selectedIndex = sender.tag
    }
    
}
