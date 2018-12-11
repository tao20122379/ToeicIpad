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
        playerController = AVAudioPlayer()
    }
    
    func playAudio(fileName:String, start:Double, end:Double) -> Void {
        timeStart = start
        timeEnd = end
        longTime = timeEnd! - timeStart!
        do {
            playerController = nil
            playerController = try AVAudioPlayer(contentsOf: FileUtil.urlOfFile(fileName: fileName))
            playerController?.numberOfLoops = 0
            playerController?.enableRate = true
            playerController?.currentTime = timeStart!
            playerController?.play()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func stop(){
        if (playerController?.isPlaying == true) {
            playerController?.stop()
            if (timeStart != nil) {
                playerController?.currentTime = timeStart!
            } else {
                playerController?.currentTime = 0
            }
       
        }
    }
    
    func pause() {
        if (playerController?.isPlaying == true) {
            playerController?.pause()
        }
    }
    
    func play() {
        if (playerController?.isPlaying == false) {
            playerController?.play()
        }
    }
    
    func resetAudio() {
        playerController?.currentTime = timeStart!
    }
    
    func getProgress() -> Float {
        if ( playerController?.currentTime != nil && longTime != nil && longTime != 0) {
            return Float(((playerController?.currentTime)! - timeStart!)/longTime!)
        }
        return 0
      
    }
    
    func getTimeFromeValue(value:Float) -> TimeInterval{
        if (longTime != nil && timeStart != nil) {
            let time = Double(value) * longTime! + timeStart!
            return time
        }
        return 0
    }
}
