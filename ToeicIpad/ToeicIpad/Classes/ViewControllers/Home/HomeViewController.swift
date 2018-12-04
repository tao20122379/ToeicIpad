//
//  HomeViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 11/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var testImage: UIImageView!
    var progressVC:ProgressDownloadViewController?
    var show: Bool = false
    var alertVC:UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func TestSelected(_ sender: Any) {
        
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (show) {
            appDelegate.hideAidoView()
            show = false
        } else {
            appDelegate.showAudioView()
            show = true
        }

        return
        
        let newVC = UIViewController()
        newVC.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(newVC, animated: true)

        return
      
        let question1: QuestionPart1 = QuestionPart1Manager.getQuestion1(question_id: 1)
        print(question1)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewVC = FirstViewController(nibName: "FirstViewController", bundle: nil)
        viewVC.view.backgroundColor = UIColor.white
        viewVC.title = "Test"
        self.navigationController?.pushViewController(viewVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }
        
        cell!.textLabel?.text = String(format: "%d", indexPath.row)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}

