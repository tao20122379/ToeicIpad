//
//  QuestionCell.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/6/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import DLRadioButton

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
//        btnA.icon = UIImage(named: "check_true")!
//        btnA.iconSelected = UIImage(named: "check_true")!
//        
//        btnB.icon = UIImage(named: "check_false")!
//        btnB.iconSelected = UIImage(named: "check_false")!
    }
    
}
