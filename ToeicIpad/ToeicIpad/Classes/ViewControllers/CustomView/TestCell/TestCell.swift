//
//  TestCell.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/10/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
protocol TestCellDelegate {
    func downloadCellSelected(test: TestBook) -> Void
}

class TestCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    var delegate: TestCellDelegate?
    var indexPath: IndexPath?
    var testData: TestBook?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        downloadBtn.imageView?.tintColor = UIColor.blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func downloadBtn(_ sender: Any) {
        if (delegate != nil && testData != nil) {
            delegate?.downloadCellSelected(test: testData!)
        }
        
    }
    
}
