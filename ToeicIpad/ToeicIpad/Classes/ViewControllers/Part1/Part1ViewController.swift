//
//  Part1ViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import Alamofire
import KRProgressHUD

class Part1ViewController: BaseViewController {
    
    @IBOutlet weak var part1TableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var part1Datas: Array<QuestionPart1> = Array<QuestionPart1>()
    var isSubmit: Bool = false
    var testData: TestBook?
    var indexTest: Int = 0
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    func initUI() -> Void {
        part1TableView.delegate = self
        part1TableView.dataSource = self
        part1TableView.backgroundView?.backgroundColor = UIColor.white
        part1TableView.rowHeight = UITableView.automaticDimension
        part1TableView.estimatedRowHeight = 80
        part1TableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCellPart1")
        part1TableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imageCellPart1")
        part1TableView.register(UINib(nibName: "SubmitCell", bundle: nil), forCellReuseIdentifier: "submitCellPart1")
        part1TableView.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "descriptionCellPart1")
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioNext), name: NSNotification.Name(Global.NOTIFICATION_NEXT), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPrev), name: NSNotification.Name(Global.NOTIFICATION_PREV), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioSelecteList(_:)), name: NSNotification.Name(Global.NOTIFICATION_SELECT_LIST), object: nil)
        
    }
    
    func initData() -> Void {
        if (part1Datas.count <= 0) {
            let audioName = String(format: "part1_%d.mp3", testData!.test_id)
            if (!FileUtil.fileExitsAtName(fileName: audioName)) {
                KRProgressHUD.show()
                DownloadClient.shareClient.alamofireDownloadAudio(name: audioName) { (isAudio) in
                    if (isAudio) {
                        self.getDataPart1()
                    }
                }
            } else {
                getDataPart1()
            }
        } else {
        }
        title = String(format: "%d/%d", indexTest + 1, part1Datas.count)
    }
    
    
    // MARK: - Service
    func getDataPart1() -> Void {
        if ((testData?.isDataPart1)!) {
            part1Datas = QuestionPart1Manager.getListQuestion1(test_id: testData?.test_id)
            self.part1TableView.reloadData()
            self.appDelegate.showAudioView()
            self.loadAudio()
        } else {
            let actionStr = "question-part1/search"
            let params = NSMutableDictionary()
            params.setValue(String(format: "%d", (testData?.test_id)!), forKey: "test_id")
            KRProgressHUD.show()
            ApiClient.shareClient.alamofireCallMethod(method: actionStr, withParams: params) { (response: DataResponse<Any>) in
                switch (response.result) {
                case .success(_):
                    if (response.result.value != nil){
                        let datas = response.result.value as! Array<Any>
                        datas.forEach({ (data) in
                            let question1 = QuestionPart1()
                            question1.initWithDatas(data: data as! NSDictionary)
                            self.part1Datas.append(question1)
                            
                        })
                    }
                    self.part1TableView.reloadData()
                    self.appDelegate.showAudioView()
                    self.loadAudio()
                    break
                case .failure(_):
                    break
                }
                if (self.part1Datas.count <= 0) {
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
        if (indexTest < part1Datas.count) {
            appDelegate.audioView?.initAudio(fileName: String(format: "part1_%d.mp3", (self.testData?.test_id)!), start: part1Datas[indexTest].time_start, end: part1Datas[indexTest].time_end)
            appDelegate.audioView?.play()
            appDelegate.audioView?.listTest = part1Datas
            appDelegate.audioView?.indexSelect = indexTest
            appDelegate.audioView?.part = 1
            appDelegate.audioView?.test = testData
            title = String(format: "%d/%d", indexTest + 1, part1Datas.count)
        } else {
            appDelegate.audioView?.removeAudio()
            appDelegate.hideAidoView()
        }
    }
    
     func loadImageView(imageView: UIImageView, imageName: String) -> Void {
        imageView.image = UIImage(named: "loading")
        if (FileUtil.fileExitsAtName(fileName: imageName)) {
            let url = FileUtil.urlOfFile(fileName: imageName)
            let data = try? Data(contentsOf: url)
            imageView.image = UIImage(data: data!)
        } else {
           
            let url = URL(string: String(format: "%@image/%@", Global.BASE_URL, imageName))
            let data = try? Data(contentsOf: url!)
            if (data != nil) {
                imageView.image = UIImage(data: data!)
            }
        }
    }

    // MARK: - Action
    @objc func audioNext() -> Void {
        if (indexTest < part1Datas.count - 1) {
            isSubmit = false
            indexTest = indexTest + 1
            loadAudio()
            part1TableView.reloadData()
        }
    }
    
    @objc func audioPrev() -> Void {
        if (indexTest > 0) {
            isSubmit = false
            loadAudio()
            indexTest = indexTest - 1
            part1TableView.reloadData()
        }
    }
    
    @objc func audioSelecteList(_ notification: NSNotification) -> Void {
        if let dict = notification.userInfo as NSDictionary? {
            if let index = dict["part1_index"] as? Int{
                isSubmit = false
                indexTest = index
                loadAudio()
                part1TableView.reloadData()
            }
        }

    }
    
}

//MARK: - TableView delegate
extension Part1ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (indexTest >= part1Datas.count) {
            return 0
        }
        if (isSubmit) {
            return 4
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCellPart1") as! ImageCell
                if (indexTest < part1Datas.count) {
                    loadImageView(imageView: cell.part1ImageView, imageName: part1Datas[indexTest].image_name)
                }
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "questionCellPart1") as! QuestionCell
                cell.questionLabel.text = ""
                if (isSubmit) {
                    cell.showDataPart1(data: part1Datas[indexTest])
                } else {
                    cell.initUI()
                }
                return cell
            case 2:
                if (isSubmit) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCellPart1") as! DescriptionCell
                    cell.descripLabel.text = part1Datas[indexTest].description_text
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0 ) {
            return 200
        }
        
        return UITableView.automaticDimension
    }
}


// MARK: - Cell Delegate
extension Part1ViewController: SubmitCellDelegate {
    func submitCellSelected() {
        isSubmit = true
        part1TableView.reloadData()
    }
}
