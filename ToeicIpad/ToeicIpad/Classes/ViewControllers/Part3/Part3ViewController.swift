//
//  Part3ViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/6/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD

class Part3ViewController: BaseViewController {

    @IBOutlet weak var part3TableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var passageDatas: Array<PassagePart3> = Array<PassagePart3>()
    var part3Questions = Array<QuestionPart3>()
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
        part3TableView.delegate = self
        part3TableView.dataSource = self
        part3TableView.rowHeight = UITableView.automaticDimension
        part3TableView.estimatedRowHeight = 80
        part3TableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCellPart1")
        part3TableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imageCellPart1")
        part3TableView.register(UINib(nibName: "SubmitCell", bundle: nil), forCellReuseIdentifier: "submitCellPart1")
        part3TableView.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "descriptionCellPart3")
    }
    
    func initData() -> Void {
        if (passageDatas.count <= 0) {
            let audioName = String(format: "part3_%d.mp3", testData!.test_id)
            if (!FileUtil.fileExitsAtName(fileName: audioName)) {
                KRProgressHUD.show()
                DownloadClient.shareClient.alamofireDownloadAudio(name: audioName) { (isAudio) in
                    if (isAudio) {
                        KRProgressHUD.dismiss()
                        self.getPassagePart3()
                    }
                }
            } else {
                getPassagePart3()
            }
        } else {
        }
        title = String(format: "%d/%d", indexTest + 1, passageDatas.count)
    }
    
    // MARK: - Service
    func getPassagePart3() -> Void {
        if ((testData?.isDataPart3)!) {
            passageDatas = QuestionPart3Manager.getPart3TestPassage(test_id: testData?.test_id)
            self.part3TableView.reloadData()
            self.appDelegate.showAudioView()
            self.loadAudio()
        } else {
            let actionStr = "passage-part3/search"
            let params = NSMutableDictionary()
            params.setValue(String(format: "%d", (testData?.test_id)!), forKey: "test_id")
            KRProgressHUD.show()
            ApiClient.shareClient.alamofireCallMethod(method: actionStr, withParams: params) { (response: DataResponse<Any>) in
                switch (response.result) {
                case .success(_):
                    if (response.result.value != nil){
                        let datas = response.result.value as! Array<Any>
                        datas.forEach({ (data) in
                            let passage3 = PassagePart3()
                            passage3.initWithDatas(data: data as! NSDictionary)
                            self.passageDatas.append(passage3)
                        })
                    }
                    self.part3TableView.reloadData()
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
    
    // MARK: - Function
    func loadAudio() -> Void {
        if (indexTest < passageDatas.count) {
            appDelegate.audioView?.initAudio(fileName: String(format: "part3_%d.mp3", (self.testData?.test_id)!), start: passageDatas[indexTest].time_start, end: passageDatas[indexTest].time_end)
            appDelegate.audioView?.play()
            appDelegate.audioView?.listTest = passageDatas
            appDelegate.audioView?.indexSelect = indexTest
            appDelegate.audioView?.part = 2
            appDelegate.audioView?.test = testData
            title = String(format: "%d/%d", indexTest + 1, passageDatas.count)
            if ((testData?.isDataPart3)!) {
               part3Questions = QuestionPart3Manager.getPart3Questions(passage_id: passageDatas[indexTest].id)
                part3TableView.reloadData()
            } else {
                
            }
        } else {
            appDelegate.audioView?.removeAudio()
            appDelegate.hideAidoView()
        }
    }
    
}

extension Part3ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (indexTest >= passageDatas.count) {
            self.noDataLabel.isHidden = false
            return 0
        }
        self.noDataLabel.isHidden = true
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


extension Part3ViewController: SubmitCellDelegate {
    func submitCellSelected() {
        isSubmit = true
        part3TableView.reloadData()
    }
}
