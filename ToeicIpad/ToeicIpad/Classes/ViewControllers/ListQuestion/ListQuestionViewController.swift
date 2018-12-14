//
//  ListQuestionViewController.swift
//  ToeicIpad
//
//  Created by macbook on 12/13/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

protocol ListQuestion_Delegate {
    func listTestSelect(index: Int) -> Void
}

class ListQuestionViewController: BaseViewController {
    
    var listTest: Array<Any>?
    var delegate: ListQuestion_Delegate?
    var countQuestion: Int = 0
   
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}


//MARK: - TableView Delegate
extension ListQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return countQuestion
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "listTestCell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "listTestCell" )
        }
        cell?.textLabel?.text = String(format: "%d", indexPath.row + 1)
        cell?.textLabel?.textAlignment = NSTextAlignment.center
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true)
        if (delegate != nil) {
            
            delegate?.listTestSelect(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }

}
