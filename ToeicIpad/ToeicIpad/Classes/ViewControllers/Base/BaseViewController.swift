//
//  BaseViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    static var audioView: AudioView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createAudioView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createAudioView() -> Void {
        if (BaseViewController.audioView == nil) {
            BaseViewController.audioView = AudioView(frame: CGRect(x: 0, y: Global.SCREEN_HEIGHT, width: Global.SCREEN_WIDTH, height:50))
            let window = UIApplication.shared.keyWindow!
            
            window.addSubview(BaseViewController.audioView!)
            
        }
    }
    
    func showAudioView() -> Void {
        UIView.animate(withDuration: 0.5) {
            BaseViewController.audioView?.transform = CGAffineTransform(translationX: 0, y: -50)
        }
    }
    
    func hideAudioView() -> Void {
        UIView.animate(withDuration: 0.5) {
            BaseViewController.audioView?.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
}
