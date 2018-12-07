//
//  SubmitCell.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/6/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
protocol SubmitCellDelegate {
    func submitCellSelected() -> Void
}

class SubmitCell: UITableViewCell {

    @IBOutlet weak var btnSubmit: UIButton!
    var delegate: SubmitCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        btnSubmit.layer.cornerRadius = 8
    }
    
    
    @IBAction func submitCellSelected(_ sender: Any) {
        if (delegate != nil) {
            delegate?.submitCellSelected()
        }
    }
    
}
