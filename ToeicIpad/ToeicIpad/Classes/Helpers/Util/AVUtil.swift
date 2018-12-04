//
//  AVUtil.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/30/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import AVFoundation

class AVUtil: NSObject, AVAudioPlayerDelegate{
    static let shareAudio: AVUtil = AVUtil()
    var playerController: AVAudioPlayer?
    var timeStart: TimeInterval?
    var timeEnd:TimeInterval?
    var longTime:TimeInterval?
    
    override init(){
       
    }
    
    func playAudio(fileName:String, start:Double, end:Double) -> Void {
        playerController = AVAudioPlayer()
        timeStart = start
        timeEnd = end
        longTime = timeEnd! - timeStart!
        do {
            playerController = nil
            playerController = try AVAudioPlayer(contentsOf: FileUtil.urlOfFile(fileName: fileName))
            playerController?.numberOfLoops = 0
            playerController?.enableRate = true
            playerController?.currentTime = timeStart!
        } catch let error as NSError {
            print(error)
        }
    }
    
    func stop(){
        if (playerController != nil && playerController?.isPlaying == true) {
            playerController?.stop()
            if (timeStart != nil) {
                playerController?.currentTime = timeStart!
            } else {
                playerController?.currentTime = 0
            }
       
        }
    }
    
    func pause() {
        if (playerController != nil && playerController?.isPlaying == true) {
            playerController?.pause()
        }
    }
    
    func play() {
        if (playerController != nil && playerController?.isPlaying == false) {
            playerController?.play()
        }
    }
    
    func resetAudio() {
        if (playerController != nil) {
            playerController?.currentTime = timeStart!
        }
    }
    
    func getProgress() -> Float {
        if (playerController != nil && longTime != nil && longTime != 0) {
            return Float(((playerController?.currentTime)! - timeStart!)/longTime!)
        }
        return 0
    }
    
    func beginString() -> String {
        if (playerController != nil && timeStart != nil) {
            return String(format: "%.2d:%.2d", Int(((playerController?.currentTime)! - timeStart!)/60), Int((playerController?.currentTime)! - timeStart!)%60)
        }
        return "00:00"
    
    }
    
    func endString() -> String {
        if (longTime == nil) {
            return "00:00"
        }
        return String(format: "%.2d:%.2d", Int(self.longTime!/60), Int(self.longTime!.truncatingRemainder(dividingBy: 60)))
    }
    
    
    func setAudioTimeValue(value:Float) -> Void {
        if (longTime != nil && timeStart != nil) {
            let time = Double(value) * longTime! + timeStart!
            playerController?.currentTime = time
          
        }
    }
    
    func isPlay() -> Bool {
        if (playerController != nil) {
            return (playerController?.isPlaying)!
        }
        return true
    }
}
