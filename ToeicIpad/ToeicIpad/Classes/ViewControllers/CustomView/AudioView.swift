//
//  AudioView.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/30/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class AudioView: UIView {
    
    var progressView: UIProgressView?
    var progressController: UISlider?
    var timeStartLb: UILabel?
    var timeEndlaLb: UILabel?
    var pauseBtn: UIButton?
    var playBtn: UIButton?
    var repeatBtn:UIButton?
    var stopBtn: UIButton?
    var timer:Timer?
    let TIME_PROGRESS = 0.03
    var isRepeat:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white


        self.progressController = UISlider(frame: CGRect(x: 10, y: 20, width: self.frame.size.width - 20, height: 30))
        self.progressController?.value = 0
        self.progressController?.maximumValue = 1
        self.progressController?.minimumValue = 0
//        self.progressController?.backgroundColor = UIColor.clear
//        self.progressController?.minimumTrackTintColor = UIColor.clear
//        self.progressController?.maximumTrackTintColor = UIColor.clear
//        self.progressController?.thumbTintColor = UIColor.clear
        self.progressController?.addTarget(self, action: #selector(sliderTouchUpInSide(sender:)), for: .touchUpInside)
        self.progressController?.addTarget(self, action: #selector(sliderTouchDown(sender:)), for: .touchDown)
        
        self.progressView = UIProgressView(frame: CGRect(x: 10, y: 20, width: self.frame.size.width - 20, height: 30))
        self.progressView?.center.y = (self.progressController?.center.y)!
        self.addSubview(self.progressView!)
        self.addSubview(self.progressController!)
        
        self.timeStartLb = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        self.addSubview(self.timeStartLb!)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initAudio(fileName: String, start: Double, end: Double) -> Void{
        AVUtil.shareAudio.playAudio(fileName: fileName, start: start, end: end)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TIME_PROGRESS, repeats: true, block: { (timer) in
            self.processAudio()
        })
    }
    
    func processAudio() -> Void {
        self.progressView?.progress = AVUtil.shareAudio.getProgress()
        self.progressController?.value = (self.progressView?.progress)!
        if ((self.progressController?.value)! >= Float(1) ) {
            self.progressController?.value = 0
            self.progressView?.progress = 0
            if (isRepeat == true){
                AVUtil.shareAudio.resetAudio()
            } else {
                timer?.invalidate()
                AVUtil.shareAudio.stop()
            }
        }
    }
    
    func play() -> Void {
        AVUtil.shareAudio.play()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TIME_PROGRESS, repeats: true, block: { (timer) in
            self.processAudio()
        })
    }
    
    func pause() -> Void {
        AVUtil.shareAudio.pause()
        timer?.invalidate()
    }
    
    @objc func progressValueChange(seder: UISlider) -> Void {
        self.timeStartLb?.text = String(format: "%f", seder.value)
    }
    
    @objc func sliderTouchDown(sender:UISlider) -> Void {
        timer?.invalidate()
    }
    
    @objc func sliderTouchUpInSide(sender:UISlider) -> Void {
        AVUtil.shareAudio.playerController?.currentTime = AVUtil.shareAudio.getTimeFromeValue(value: sender.value)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TIME_PROGRESS, repeats: true, block: { (timer) in
            self.processAudio()
        })
    }

}
