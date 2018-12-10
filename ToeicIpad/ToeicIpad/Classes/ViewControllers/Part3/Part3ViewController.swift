//
//  Part3ViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/6/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class Part3ViewController: BaseViewController {

    @IBOutlet weak var part3TableView: UITableView!
    let passage3Data = QuestionPart3Manager.getPart3Passages(passage_id: 1)
    let part3Questions = QuestionPart3Manager.getPart3Questions(passage_id: 1)
    var isSubmit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showAudioView()
        appDelegate.audioView?.initAudio(fileName: "1.mp3", start: 0, end: 20)
        title = "part3"
        initTableView()
    }
    
    func initTableView() -> Void {
        part3TableView.delegate = self
        part3TableView.dataSource = self
        part3TableView.rowHeight = UITableView.automaticDimension
        part3TableView.estimatedRowHeight = 80
        part3TableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCellPart1")
        part3TableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imageCellPart1")
        part3TableView.register(UINib(nibName: "SubmitCell", bundle: nil), forCellReuseIdentifier: "submitCellPart1")
        part3TableView.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "descriptionCellPart3")
    }
    
}

extension Part3ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSubmit) {
            return (part3Questions.count + 2)
        }
        return (part3Questions.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row <= 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCellPart1") as! QuestionCell
            let questionData = part3Questions[indexPath.row]
            cell.questionLabel.text = String(format: "%d. %@", indexPath.row + 1, questionData.question)
            cell.answerALabel.text = String(format: "(A) %@", questionData.answerA)
            cell.answerBLabel.text = String(format: "(B) %@", questionData.answerB)
            cell.answerCLabel.text = String(format: "(C) %@", questionData.answerC)
            cell.answerDLabel.text = String(format: "(D) %@", questionData.answerD)
            if (isSubmit) {
                cell.showDataPart3(data: questionData)
            }
 
            return cell
        } else if (indexPath.row == 3) {
            if (isSubmit){
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCellPart3") as! DescriptionCell
                cell.descripLabel.text = passage3Data.passage
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


extension Part3ViewController: SubmitCellDelegate {
    func submitCellSelected() {
        isSubmit = true
        part3TableView.reloadData()
    }
}
