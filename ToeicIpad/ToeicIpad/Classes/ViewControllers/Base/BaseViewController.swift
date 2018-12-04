//
//  BaseViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let audioHeight:CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initAudio(fileName: String, start: Double, end: Double) -> Void{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.audioView?.initAudio(fileName: fileName, start: start, end: end)
        appDelegate.audioView?.play()
    }
    
}
