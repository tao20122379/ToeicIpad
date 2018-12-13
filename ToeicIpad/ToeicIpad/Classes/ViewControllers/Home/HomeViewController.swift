//
//  HomeViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import KRProgressHUD
import KRActivityIndicatorView

enum PartType: Int {
    case part1 = 1, part2, part3, part4
}

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var testImage: UIImageView!
    let listParts = [["type":"1", "title":"Part1: Photo"],
                     ["type":"2", "title":"Part2: Question - Response"],
                     ["type":"3", "title":"Part3: Short Conversation"],
                     ["type":"4", "title":"Part4: Short Tallks"],
                     ["type":"5", "title":"All Test"]
                     ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        initData()
    }
    
    func initData() -> Void {
        //DownloadClient.shareClient.downloadBooks()
        //DownloadClient.shareClient.downloadTests()
//        DownloadClient.shareClient.downloadDataPart1(test_id: "1")
//        DownloadClient.shareClient.downloadDataPart2(test_id: "1")
//        DownloadClient.shareClient.downloadPassagePart3(test_id: "1")
//        DownloadClient.shareClient.downloadQuesionPart3(test_id: "1")
//        DownloadClient.shareClient.downloadPassagePart4(test_id: "1")
//        DownloadClient.shareClient.downloadQuesionPart4(test_id: "1")
        
//        DownloadClient.shareClient.downloadAudio(name: "part1_1.mp3") { (url, error) in
//            print(error)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func TestSelected(_ sender: UIButton) {
    }
    

}



extension HomeViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listParts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listTestVC = ListTestViewController(nibName: "ListTestViewController", bundle: nil)
      
        let type = listParts[indexPath.row]["type"]
   
        listTestVC.type = PartType(rawValue: Int(type!)!)
        self.navigationController?.pushViewController(listTestVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }
        let cellData = listParts[indexPath.row]
        cell!.textLabel?.text = cellData["title"]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}
