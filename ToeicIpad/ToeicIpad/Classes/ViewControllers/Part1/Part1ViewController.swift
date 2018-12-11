//
//  Part1ViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class Part1ViewController: BaseViewController {
    
    @IBOutlet weak var part1TableView: UITableView!

    var part1Data = QuestionPart1Manager.getQuestion1(question_id: 1)
    var isSubmit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showAudioView()
        appDelegate.audioView?.initAudio(fileName: "1.mp3", start: 0, end: 20)
        title = "part1"
        initTableView()
    }
    
    
    func initTableView() -> Void {
        part1TableView.delegate = self
        part1TableView.dataSource = self
        part1TableView.rowHeight = UITableView.automaticDimension
        part1TableView.estimatedRowHeight = 80
        part1TableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCellPart1")
        part1TableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imageCellPart1")
        part1TableView.register(UINib(nibName: "SubmitCell", bundle: nil), forCellReuseIdentifier: "submitCellPart1")
        part1TableView.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "descriptionCellPart1")
    }
    
    func getDataPart1() -> Void {
        
    }


}

extension Part1ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSubmit) {
            return 4
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCellPart1") as! ImageCell
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionCellPart1") as! QuestionCell
                cell.questionLabel.text = ""
                if (isSubmit) {
                    cell.showDataPart1(data: part1Data)
                }
                return cell
            case 2:
                if (isSubmit) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCellPart1") as! DescriptionCell
                    cell.descripLabel.text = part1Data.description_text
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "submitCellPart1") as! SubmitCell
                if (isSubmit) {
                    cell.btnSubmit.isEnabled = false
                } else {
                    cell.btnSubmit.isEnabled = true
                }
                cell.delegate = self
                return cell
            
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "submitCellPart1") as! SubmitCell
                if (isSubmit) {
                    cell.btnSubmit.isEnabled = false
                } else {
                    cell.btnSubmit.isEnabled = true
                }
                cell.delegate = self
                return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}

extension Part1ViewController: SubmitCellDelegate {
    func submitCellSelected() {
        isSubmit = true
        part1TableView.reloadData()
    }
}
