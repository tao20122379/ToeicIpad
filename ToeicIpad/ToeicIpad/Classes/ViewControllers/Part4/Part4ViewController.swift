//
//  Part4ViewController.swift
//  ToeicIpad
//
//  Created by DungLM4 on 12/10/18.
//  Copyright © 2018 DungLM4. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD

class Part4ViewController: BaseViewController {
    
    @IBOutlet weak var part4TableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var passageDatas: Array<PassagePart4> = Array<PassagePart4>()
    var part4Questions = Array<QuestionPart4>()
    var isSubmit: Bool = false
    var testData: TestBook?
    var indexTest: Int = 0
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    func initUI() -> Void {
        part4TableView.delegate = self
        part4TableView.dataSource = self
        part4TableView.rowHeight = UITableView.automaticDimension
        part4TableView.estimatedRowHeight = 80
        part4TableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCellPart1")
        part4TableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imageCellPart1")
        part4TableView.register(UINib(nibName: "SubmitCell", bundle: nil), forCellReuseIdentifier: "submitCellPart1")
        part4TableView.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "descriptionCellPart4")
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioNext), name: NSNotification.Name(String(format:"%@%d", Global.NOTIFICATION_NEXT, 4)), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPrev), name: NSNotification.Name(String(format:"%@%d", Global.NOTIFICATION_PREV, 4)), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioSelecteList(_:)), name: NSNotification.Name(String(format:"%@%d", Global.NOTIFICATION_SELECT_LIST, 4)), object: nil)
    }
    
    func initData() -> Void {
        if (passageDatas.count <= 0) {
            let audioName = String(format: "part4_%d.mp3", testData!.test_id)
            if (!FileUtil.fileExitsAtName(fileName: audioName)) {
                KRProgressHUD.show()
                DownloadClient.shareClient.alamofireDownloadAudio(name: audioName) { (isAudio) in
                    if (isAudio) {
                        KRProgressHUD.dismiss()
                        self.getPassagePart4()
                    } else {
                        self.appDelegate.audioView?.removeAudio()
                        self.appDelegate.hideAidoView()
                    }
                    KRProgressHUD.dismiss()
                }
            } else {
                getPassagePart4()
            }
        } else {
            getQuestionsPart4()
        }
        title = String(format: "%d/%d", indexTest + 1, passageDatas.count)
    }
    
    // MARK: - Service
    func getPassagePart4() -> Void {
        if ((testData?.isDataPart4)!) {
            passageDatas = QuestionPart4Manager.getPart4TestPassage(test_id: testData?.test_id)
            getQuestionsPart4()
            self.part4TableView.reloadData()
            self.appDelegate.showAudioView()
            self.loadAudio()
        } else {
            let actionStr = "passage-part4/search"
            let params = NSMutableDictionary()
            params.setValue(String(format: "%d", (testData?.test_id)!), forKey: "test_id")
            KRProgressHUD.show()
            ApiClient.shareClient.alamofireCallMethod(method: actionStr, withParams: params) { (response: DataResponse<Any>) in
                switch (response.result) {
                case .success(_):
                    if (response.result.value != nil){
                        let datas = response.result.value as! Array<Any>
                        datas.forEach({ (data) in
                            let passage4 = PassagePart4()
                            passage4.initWithDatas(data: data as! NSDictionary)
                            self.passageDatas.append(passage4)
                        })
                    }
                    self.getQuestionsPart4()
                    self.part4TableView.reloadData()
                    self.appDelegate.showAudioView()
                    self.loadAudio()
                    break
                case .failure(_):
                    break
                }
                KRProgressHUD.dismiss()
            }
        }
    }
    
    func getQuestionsPart4() {
        if (indexTest < passageDatas.count) {
            if ((testData?.isDataPart4)!) {
                part4Questions = QuestionPart4Manager.getPart4Questions(passage_id: passageDatas[indexTest].id)
                part4TableView.reloadData()
            } else {
                let actionStr = "question-part4/search"
                let params = NSMutableDictionary()
                params.setValue(String(format: "%d", passageDatas[indexTest].id), forKey: "passage_id")
                KRProgressHUD.show()
                ApiClient.shareClient.alamofireCallMethod(method: actionStr, withParams: params) { (response: DataResponse<Any>) in
                    switch (response.result) {
                    case .success(_):
                        if (response.result.value != nil){
                            let datas = response.result.value as! Array<Any>
                            self.part4Questions.removeAll()
                            datas.forEach({ (data) in
                                let question4 = QuestionPart4()
                                question4.initWithDatas(data: data as! NSDictionary)
                                self.part4Questions.append(question4)
                            })
                        }
                        self.part4TableView.reloadData()
                        break
                    case .failure(_):
                        break
                    }
                    
                    KRProgressHUD.dismiss()
                }
            }
        }
    }
    
    // MARK: - Function
    func loadAudio() -> Void {
        if (indexTest < passageDatas.count) {
            getQuestionsPart4()
            appDelegate.audioView?.initAudio(fileName: String(format: "part4_%d.mp3", (self.testData?.test_id)!), start: passageDatas[indexTest].time_start, end: passageDatas[indexTest].time_end)
            appDelegate.audioView?.play()
            appDelegate.audioView?.listTest = passageDatas
            appDelegate.audioView?.indexSelect = indexTest
            appDelegate.audioView?.part = 4
            appDelegate.audioView?.test = testData
            title = String(format: "%d/%d", indexTest + 1, passageDatas.count)
        } else {
            appDelegate.audioView?.removeAudio()
            appDelegate.hideAidoView()
        }
    }
    
    // MARK: - Action
    @objc func audioNext() -> Void {
        if (indexTest < passageDatas.count - 1) {
            isSubmit = false
            indexTest = indexTest + 1
            loadAudio()
            part4TableView.reloadData()
        }
    }
    
    @objc func audioPrev() -> Void {
        if (indexTest > 0) {
            isSubmit = false
            loadAudio()
            indexTest = indexTest - 1
            part4TableView.reloadData()
        }
    }
    
    @objc func audioSelecteList(_ notification: NSNotification) -> Void {
        if let dict = notification.userInfo as NSDictionary? {
            if let index = dict["part1_index"] as? Int{
                isSubmit = false
                indexTest = index
                loadAudio()
                part4TableView.reloadData()
            }
        }
        
    }
    
}

extension Part4ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (indexTest >= passageDatas.count || part4Questions.count <= 0) {
            self.noDataLabel.isHidden = false
            return 0
        }
        self.noDataLabel.isHidden = true
        if (isSubmit) {
            return (part4Questions.count + 2)
        }
        return (part4Questions.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row <= 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCellPart1") as! QuestionCell
            let questionData = part4Questions[indexPath.row]
            if (isSubmit) {
                cell.showDataPart4(data: questionData)
            } else {
                cell.initUI()
            }
            cell.questionLabel.text = String(format: "%d. %@", indexPath.row + 1, questionData.question)
            cell.answerALabel.text = String(format: "(A) %@", questionData.answerA)
            cell.answerBLabel.text = String(format: "(B) %@", questionData.answerB)
            cell.answerCLabel.text = String(format: "(C) %@", questionData.answerC)
            cell.answerDLabel.text = String(format: "(D) %@", questionData.answerD)
            
            return cell
        } else if (indexPath.row == 4) {
            if (isSubmit){
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCellPart4") as! DescriptionCell
                cell.descripLabel.text = passageDatas[indexTest].description_text
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
