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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showAudioView()
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
        
    }

    @IBAction func testSelected(_ sender: Any) {
        self.downloadImage(name: "1.png")
        
    }
}

extension Part1ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCellPart1") as! ImageCell
            return cell
        } else if (indexPath.row == 1) {
             let cell = tableView.dequeueReusableCell(withIdentifier: "questionCellPart1") as! QuestionCell
            cell.questionLabel.text = ""
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "submitCellPart1") as! SubmitCell
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}
