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
    var progressVC:ProgressDownloadViewController?
    var alertVC:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAlertView()
        let rightBarButton = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(audioSelected))
        rightBarButton.image = UIImage(named: "music")
        self.navigationItem.rightBarButtonItem = rightBarButton
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createAlertView() -> Void {
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
    }
    
    func downloadImage(name:String) -> Void {
        let downloadRequest = DownloadClient();
        downloadRequest.delegate = self
        if (FileUtil.fileExitsAtName(fileName: name) == false) {
            self.present(alertVC!, animated: true) {
                downloadRequest.downloadImage(name: name) { (url, response) in
                }
            }
        }
    }
    
    @objc func audioSelected() -> Void {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        if (appdelegate.audioIsShow) {
            appdelegate.hideAidoView()
        } else {
            appdelegate.showAudioView()
        }
    }
}

extension BaseViewController:DownloadClientDelegate {
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

