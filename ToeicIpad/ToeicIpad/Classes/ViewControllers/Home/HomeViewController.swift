//
//  HomeViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var testImage: UIImageView!
    var progressVC:ProgressDownloadViewController?
    var alertVC:UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAudioView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func TestSelected(_ sender: Any) {

        let newVC = UIViewController()
        newVC.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(newVC, animated: true)
  
        BaseViewController.audioView?.initAudio(fileName: "1.mp3", start: 10, end: 20)
        return
      


        
        let question1: QuestionPart1 = QuestionPart1Manager.getQuestion1(question_id: 1)
        print(question1)
    }
    
    @IBAction func stopAction(_ sender: Any) {
        
      
    }
    
    @IBAction func pauseAction(_ sender: Any) {
      BaseViewController.audioView!.pause()
    }
    
    @IBAction func palyAction(_ sender: Any) {
        BaseViewController.audioView!.play()
    }
    
    
    
    func showProgressDownload() -> Void {
        let downloadRequest = DownloadClient();
        downloadRequest.delegate = self
        
        progressVC = ProgressDownloadViewController(nibName: "ProgressDownloadViewController", bundle: nil)
        
        alertVC = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
        }
        alertVC?.addAction(cancelAction)
        let customView = UIView()
        alertVC?.view.addSubview(customView)
        Util.SetContraintCustomViewAlert(alertVC: alertVC!, customView: customView)
        progressVC?.view.frame = CGRect(x: 0, y: 0, width: customView.frame.size.width, height: customView.frame.size.height)
        progressVC?.view.backgroundColor = UIColor.clear
        customView.addSubview((progressVC?.view)!)
        if (FileUtil.fileExitsAtName(fileName: "1.png") == false) {
            self.present(alertVC!, animated: true) {
                downloadRequest.downloadImage(name: "1.png") { (url, response) in
                }
            }
        }
        let filePath = FileUtil.pathOfFile(fileName: "1.png")
        testImage.image = UIImage(contentsOfFile: filePath)
    }
}


extension HomeViewController:DownloadClientDelegate {
    func downloadClientCompleteHandler(filePath: String) {
        progressVC = nil
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func downloadClientErrorHandler(error: NSError?) {
        DispatchQueue.main.async {
            self.progressVC = nil
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func downloadClientProgressHandler(progress: Float, fileSize: Float) {
        DispatchQueue.main.async {
            self.progressVC?.downloadProgress.progress = progress
        }
    }
    
}

