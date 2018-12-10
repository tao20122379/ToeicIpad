//
//  Part4ViewController.swift
//  ToeicIpad
//
//  Created by DungLM4 on 12/10/18.
//  Copyright © 2018 DungLM4. All rights reserved.
//

import UIKit

class Part4ViewController: BaseViewController {
    
    let passage4Data = QuestionPart4Manager.getPart4Passages(passage_id: 1)
    let part4Questions = QuestionPart4Manager.getPart4Questions(passage_id: 1)
    var isSubmit: Bool = false
    
    @IBOutlet weak var part4TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showAudioView()
        appDelegate.audioView?.initAudio(fileName: "1.mp4", start: 0, end: 20)
        title = "part4"
        initTableView()
    }
    
    func initTableView() -> Void {
        part4TableView.delegate = self
        part4TableView.dataSource = self
        part4TableView.rowHeight = UITableView.automaticDimension
        part4TableView.estimatedRowHeight = 80
        part4TableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCellPart1")
        part4TableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imageCellPart1")
        part4TableView.register(UINib(nibName: "SubmitCell", bundle: nil), forCellReuseIdentifier: "submitCellPart1")
        part4TableView.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "descriptionCellPart4")
        
    }
    
}

extension Part4ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSubmit) {
            return (part4Questions.count + 2)
        }
        return (part4Questions.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row <= 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCellPart1") as! QuestionCell
            let questionData = part4Questions[indexPath.row]
            cell.questionLabel.text = String(format: "%d. %@", indexPath.row + 1, questionData.question)
            cell.answerALabel.text = String(format: "(A) %@", questionData.answerA)
            cell.answerBLabel.text = String(format: "(B) %@", questionData.answerB)
            cell.answerCLabel.text = String(format: "(C) %@", questionData.answerC)
            cell.answerDLabel.text = String(format: "(D) %@", questionData.answerD)
            if (isSubmit) {
                cell.showDataPart4(data: questionData)
            }
            
            return cell
        } else if (indexPath.row == 4) {
            if (isSubmit){
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCellPart4") as! DescriptionCell
                cell.descripLabel.text = passage4Data.passage
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "submitCellPart1") as! SubmitCell
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "submitCellPart1") as! SubmitCell
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}


extension Part4ViewController: SubmitCellDelegate {
    func submitCellSelected() {
        isSubmit = true
        part4TableView.reloadData()
    }
}
