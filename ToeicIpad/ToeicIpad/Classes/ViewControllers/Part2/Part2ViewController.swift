//
//  Part2ViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/6/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class Part2ViewController: BaseViewController {

    @IBOutlet weak var part2TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showAudioView()
        title = "part2"
        initTableView()
    }
    
    func initTableView() -> Void {
        part2TableView.delegate = self
        part2TableView.dataSource = self
        part2TableView.rowHeight = UITableView.automaticDimension
        part2TableView.estimatedRowHeight = 80
        part2TableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCellPart2")
        part2TableView.register(UINib(nibName: "SubmitCell", bundle: nil), forCellReuseIdentifier: "submitCellPart2")
        
    }

}


extension Part2ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCellPart2") as! QuestionCell
            cell.answerDLabel.text = ""
            cell.btnD.isHidden = true
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "submitCellPart2") as! SubmitCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}
