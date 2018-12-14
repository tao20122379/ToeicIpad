//
//  AudioView.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/30/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class AudioView: UIView {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressController: UISlider!
    @IBOutlet weak var timeStartLb: UILabel!
    @IBOutlet weak var timeEndLb: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var speedBtn: UIButton!
    
    var pauseBtn:UIButton?
    var repeatBtn:UIButton?
    var stopBtn:UIButton?
    var timer:Timer?
    let TIME_PROGRESS = 0.05
    var isRepeat:Bool = true
    var view:UIView!
    var isCurrentlyPlayingHidden = false
    let speeds = ["1.5", "1.25", "1", "0.75", "0.5", "0.25"]
    var listTest: Array<Any> = Array<Any>()
    var test: TestBook?
    var part: Int = 0
    var indexSelect: Int = 0
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        progressController.setThumbImage(UIImage(named: "thump"), for: UIControl.State.normal)
    }
    
    func initAudio(fileName: String, start: Double, end: Double) -> Void{
        AVUtil.shareAudio.playAudio(fileName: fileName, start: start, end: end)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TIME_PROGRESS, repeats: true, block: { (timer) in
            self.processAudio()
        })
        self.timeEndLb.text = AVUtil.shareAudio.endString()
    }
    
    func initTabBar(tabbar: UITabBar) -> Void {
        self.tabBar.items = tabBar.items
        self.tabBar.selectedItem = tabBar.selectedItem
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutIfNeeded()
    }
    
    func processAudio() -> Void {
        self.progressView?.progress = AVUtil.shareAudio.getProgress()
        self.progressController?.value = (self.progressView?.progress)!
        if ((self.progressController?.value)! >= Float(1) ) {
            self.progressController?.value = 0
            self.progressView?.progress = 0
            AVUtil.shareAudio.resetAudio()
            if (isRepeat == false){
                self.pause()
                timer?.invalidate()
            }
        }
        timeStartLb.text = AVUtil.shareAudio.beginString()
    }
    
    func removeAudio() -> Void {
        pause()
        AVUtil.shareAudio.removeAudio()
        processAudio()
        part = 0
        indexSelect = 0
        listTest.removeAll()
        test = nil
    }
    
    //MARK: - Action
    func play() -> Void {
        AVUtil.shareAudio.play()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TIME_PROGRESS, repeats: true, block: { (timer) in
            self.processAudio()
        })
        playBtn.setImage(UIImage(named: "audio_play"), for: .normal)
    }
    
    func pause() -> Void {
        AVUtil.shareAudio.pause()
        timer?.invalidate()
        playBtn.setImage(UIImage(named: "audio_pause"), for: .normal)
    }
    
    @IBAction func sliderTouchDown(_ sender: UISlider) {
        self.timer?.invalidate()
    }
    
    @IBAction func sliderTouchUpiInside(_ sender: UISlider) {
        AVUtil.shareAudio.setAudioTimeValue(value: sender.value)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TIME_PROGRESS, repeats: true, block: { (timer) in
            self.processAudio()
        })
    }
    
    @IBAction func playSelected(_ sender: UIButton) {
        
        if (AVUtil.shareAudio.isPlay()) {
            self.pause()
        } else {
            self.play()
        }
    }
    
    @IBAction func sliderDrag(_ sender: UISlider) {
        AVUtil.shareAudio.setAudioTimeValue(value: sender.value)
        timeStartLb.text = AVUtil.shareAudio.beginString()
    }
    
    @IBAction func btnSpeedSelected(_ sender: UIButton) {
        let popVC = SpeedTableView()
        popVC.speeds = speeds
        popVC.view.backgroundColor = UIColor.white
        popVC.delegate = self
        Util.showPopover(popVC: popVC, root: self, sender: sender, size: CGSize(width: 65, height: speeds.count*Global.CELL_SPEED_HEIGHT))
    }
    
    
    @IBAction func btnRepeatSelected(_ sender: UIButton) {
        if (isRepeat) {
            isRepeat = false
            sender.tintColor = UIColor.black
        } else {
            isRepeat = true
            sender.tintColor = Util.hexStringToUIColor(hex: "0096FF")
        }
    }
    
    @IBAction func btnNextSelected(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(Global.NOTIFICATION_NEXT), object: nil)
    }
    
    @IBAction func btnPrevSelected(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(Global.NOTIFICATION_PREV), object: nil)
    }
    
    @IBAction func listBtnSelected(_ sender: UIButton) {
        if ((listTest.count) > 0) {
            appDelegate.openTestVCPart(part: part, data: listTest, index: indexSelect, test: test!)
            let listQuestionVC = ListQuestionViewController(nibName: "ListQuestionViewController", bundle: nil)
            listQuestionVC.countQuestion = (self.listTest.count)
            listQuestionVC.delegate = self
            Util.showPopover(popVC: listQuestionVC, root: self, sender: sender, size: CGSize(width: 80, height: 460))
        }
    }
    
}

extension AudioView: ListQuestion_Delegate {
    func listTestSelect(index: Int) {
        NotificationCenter.default.post(name: NSNotification.Name(Global.NOTIFICATION_SELECT_LIST), object: nil, userInfo: ["part1_index": index])
    }
}

extension AudioView: SpeedTable_Delegate {
    func slecteedSpeed(speed: String) {
        speedBtn.setTitle(String(format: "%@ x", speed), for: UIControl.State.normal)
        AVUtil.shareAudio.setSpeed(speed: Float(speed)!)
    }
}

extension AudioView: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


protocol SpeedTable_Delegate {
    func slecteedSpeed(speed:String) -> Void
}

class SpeedTableView: UITableViewController {
    
    var speeds: Array<String>?
    var delegate: SpeedTable_Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (speeds?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "speedCell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "speedCell")
        }
        cell?.layoutMargins = UIEdgeInsets.zero
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.textLabel?.text = String(format: "%@", speeds![indexPath.row])
        cell?.textLabel?.textAlignment = NSTextAlignment.center
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.textLabel?.textColor = Util.hexStringToUIColor(hex: "0096FF")
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Global.CELL_SPEED_HEIGHT)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.slecteedSpeed(speed: self.speeds![indexPath.row])
        }
    }
}
