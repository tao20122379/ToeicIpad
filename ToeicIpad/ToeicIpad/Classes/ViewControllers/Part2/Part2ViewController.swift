//
//  Part2ViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/6/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD

class Part2ViewController: BaseViewController {

    @IBOutlet weak var part2TableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
   // let part2Datas = QuestionPart2Manager.getQuestion2(question_id: 1)
    var part2Datas: Array<QuestionPart2> = Array<QuestionPart2>()
    var isSubmit: Bool = false
    var testData: TestBook?
    var indexTest: Int = 0
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    func initUI() -> Void {
        part2TableView.delegate = self
        part2TableView.dataSource = self
        part2TableView.rowHeight = UITableView.automaticDimension
        part2TableView.estimatedRowHeight = 80
        part2TableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCellPart2")
        part2TableView.register(UINib(nibName: "SubmitCell", bundle: nil), forCellReuseIdentifier: "submitCellPart2")
        part2TableView.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "descriptionCellPart2")
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioNext), name: NSNotification.Name(String(format:"%@%d", Global.NOTIFICATION_NEXT, 2)), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPrev), name: NSNotification.Name(String(format:"%@%d", Global.NOTIFICATION_PREV, 2)), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioSelecteList(_:)), name: NSNotification.Name(String(format:"%@%d", Global.NOTIFICATION_SELECT_LIST, 2)), object: nil)
    }
    
    func initData() -> Void {
        if (part2Datas.count <= 0) {
            let audioName = String(format: "part2_%d.mp3", testData!.test_id)
            if (!FileUtil.fileExitsAtName(fileName: audioName)) {
                KRProgressHUD.show()
                DownloadClient.shareClient.alamofireDownloadAudio(name: audioName) { (isAudio) in
                    if (isAudio) {
                        self.getDataPart2()
                    } else {
                        self.appDelegate.audioView?.removeAudio()
                        self.appDelegate.hideAidoView()
                    }
                     KRProgressHUD.dismiss()
                }
            } else {
                getDataPart2()
            }
        } else {
        }
        title = String(format: "%d/%d", indexTest + 1, part2Datas.count)
    }
    
    // MARK: - Service
    func getDataPart2() -> Void {
        if ((testData?.isDataPart2)!) {
            part2Datas = QuestionPart2Manager.getListQuestion2(test_id: testData?.test_id)
            self.part2TableView.reloadData()
            self.appDelegate.showAudioView()
            self.loadAudio()
        } else {
            let actionStr = "question-part2/search"
            let params = NSMutableDictionary()
            params.setValue(String(format: "%d", (testData?.test_id)!), forKey: "test_id")
            KRProgressHUD.show()
            ApiClient.shareClient.alamofireCallMethod(method: actionStr, withParams: params) { (response: DataResponse<Any>) in
                switch (response.result) {
                case .success(_):
                    if (response.result.value != nil){
                        let datas = response.result.value as! Array<Any>
                        datas.forEach({ (data) in
                            let question2 = QuestionPart2()
                            question2.initWithDatas(data: data as! NSDictionary)
                            self.part2Datas.append(question2)
                        })
                    }
                    self.part2TableView.reloadData()
                    self.appDelegate.showAudioView()
                    self.loadAudio()
                    break
                case .failure(_):
                    break
                }
                if (self.part2Datas.count <= 0) {
                    self.noDataLabel.isHidden = false
                } else {
                    self.noDataLabel.isHidden = true
                }
                KRProgressHUD.dismiss()
            }
        }
    }
    
    // MARK: - Function
    func loadAudio() -> Void {
        if (indexTest < part2Datas.count) {
            appDelegate.audioView?.initAudio(fileName: String(format: "part2_%d.mp3", (self.testData?.test_id)!), start: part2Datas[indexTest].time_start, end: part2Datas[indexTest].time_end)
            appDelegate.audioView?.play()
            appDelegate.audioView?.listTest = part2Datas
            appDelegate.audioView?.indexSelect = indexTest
            appDelegate.audioView?.part = 2
            appDelegate.audioView?.test = testData
            title = String(format: "%d/%d", indexTest + 1, part2Datas.count)
        } else {
            appDelegate.audioView?.removeAudio()
            appDelegate.hideAidoView()
        }
    }
    
    // MARK: - Action
    @objc func audioNext() -> Void {
        if (indexTest < part2Datas.count - 1) {
            isSubmit = false
            indexTest = indexTest + 1
            loadAudio()
            part2TableView.reloadData()
        }
    }
    
    @objc func audioPrev() -> Void {
        if (indexTest > 0) {
            isSubmit = false
            loadAudio()
            indexTest = indexTest - 1
            part2TableView.reloadData()
        }
    }
    
    @objc func audioSelecteList(_ notification: NSNotification) -> Void {
        if let dict = notification.userInfo as NSDictionary? {
            if let index = dict["part1_index"] as? Int{
                isSubmit = false
                indexTest = index
                loadAudio()
                part2TableView.reloadData()
            }
        }
        
    }

}

// MARK: - TableView delegate
extension Part2ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (indexTest >= part2Datas.count) {
            self.noDataLabel.isHidden = false
            return 0
        }
        self.noDataLabel.isHidden = true
        if (isSubmit) {
            return 3
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCellPart2") as! QuestionCell
            if (isSubmit) {
                cell.showDataPart2(data: part2Datas[indexTest])
            } else {
                cell.initUI()
            }
            cell.answerDLabel.text = ""
            cell.btnD.isHidden = true
            return cell
        case 1:
            if (isSubmit) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCellPart2") as! DescriptionCell
                cell.descripLabel.text = part2Datas[indexTest].description_text
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "submitCellPart2") as! SubmitCell
            cell.delegate = self
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "submitCellPart2") as! SubmitCell
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

extension Part2ViewController: SubmitCellDelegate {
    func submitCellSelected() {
        isSubmit = true
        part2TableView.reloadData()
    }
}
