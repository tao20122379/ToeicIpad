//
//  AudioViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/31/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class AudioViewController: UIViewController {


    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressController: UISlider!
    @IBOutlet weak var timeStartLb: UILabel!
    @IBOutlet weak var timeEndLb: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    var pauseBtn: UIButton?
    var repeatBtn:UIButton?
    var stopBtn: UIButton?
    var timer:Timer?
    let TIME_PROGRESS = 0.1
    var isRepeat:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initAudio(fileName: String, start: Double, end: Double) -> Void{
        AVUtil.shareAudio.playAudio(fileName: fileName, start: start, end: end)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TIME_PROGRESS, repeats: true, block: { (timer) in
            self.processAudio()
        })
        self.timeEndLb.text = AVUtil.shareAudio.endString()
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
                AVUtil.shareAudio.stop()
                timer?.invalidate()
                
            }
        }
        timeStartLb.text = AVUtil.shareAudio.beginString()
    }
    
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
    
    @IBAction func sliderTouchDown(_ sender: Any) {
         timer?.invalidate()
    }
    
    
    @IBAction func sliderTouchUpInSide(_ sender: UISlider) {
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
    

 
}
