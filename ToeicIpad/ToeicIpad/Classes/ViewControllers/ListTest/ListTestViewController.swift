//
//  ListTestViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit
import KRProgressHUD
import KRActivityIndicatorView

class ListTestViewController: BaseViewController {
    
    @IBOutlet weak var listTestTableView: UITableView!
    
    var type: Int = 0
    var listTests = TestManager.getAllTests()
    var part1VC: Part1ViewController?
    var part2VC: Part2ViewController?
    var part3VC: Part3ViewController?
    var part4VC: Part4ViewController?
    var openTestPart: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        if (UserDefaults.standard.bool(forKey: Global.IS_FIRST_LOGIN)){
            initData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openTest()
    }
    
    func initUI() -> Void {
        listTestTableView.delegate = self
        listTestTableView.dataSource = self
        listTestTableView.register(UINib(nibName: "TestCell", bundle: nil), forCellReuseIdentifier: "testCell")
        title = String(format: "Part %d", type)
    }
    
    func initData() -> Void {
        KRProgressHUD.show()
        DownloadClient.shareClient.downloadTests { (sucess) in
             let delay = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.listTests = TestManager.getAllTests()
                self.listTestTableView.reloadData()
                UserDefaults.standard.set(false, forKey: Global.IS_FIRST_LOGIN)
                KRProgressHUD.dismiss()
            }
        }
    }
    
    func reloadTableView() -> Void {
        listTests = TestManager.getAllTests()
        listTestTableView.reloadData()
    }
    
    func openTest() -> Void {
        switch openTestPart {
        case 1:
            if (part1VC != nil) {
                openTestPart = 0
                self.navigationController?.pushViewController(part1VC!, animated: true)
            }
            break
        case 2:
            if (part2VC != nil) {
                openTestPart = 0
                self.navigationController?.pushViewController(part2VC!, animated: true)
            }
            break
        case 3:
            if (part3VC != nil) {
                openTestPart = 0
                self.navigationController?.pushViewController(part3VC!, animated: true)
            }
            break
        case 4:
            if (part4VC != nil) {
                openTestPart = 0
                self.navigationController?.pushViewController(part4VC!, animated: true)
            }
            break
        default:
            break
        }
    }
    
}

extension ListTestViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell") as! TestCell
        let testData = listTests[indexPath.row]
        switch type {
        case 1:
            cell.downloadBtn.isHidden = testData.isDataPart1
            break
        case 2:
            cell.downloadBtn.isHidden = testData.isDataPart2
            break
        case 3:
            cell.downloadBtn.isHidden = testData.isDataPart3
            break
        case 4:
            cell.downloadBtn.isHidden = testData.isDataPart4
            break
        default:
            break
        }
        cell.delegate = self
        cell.testData = testData
        cell.indexPath = indexPath
        cell.titleLabel.text = testData.test_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case 1:
            let part1VC = Part1ViewController(nibName: "Part1ViewController", bundle: nil)
            part1VC.testData = listTests[indexPath.row]
            self.navigationController?.pushViewController(part1VC, animated: true)
            break
        case 2:
            let part2VC = Part2ViewController(nibName: "Part2ViewController", bundle: nil)
            part2VC.testData = listTests[indexPath.row]
            self.navigationController?.pushViewController(part2VC, animated: true)
            break
        case 3:
            let part3VC = Part3ViewController(nibName: "Part3ViewController", bundle: nil)
            part3VC.testData = listTests[indexPath.row]
            self.navigationController?.pushViewController(part3VC, animated: true)
            break
        case 4:
            let part4VC = Part4ViewController(nibName: "Part4ViewController", bundle: nil)
            part4VC.testData = listTests[indexPath.row]
            self.navigationController?.pushViewController(part4VC, animated: true)
            break
        default:
            break
        }

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}

extension ListTestViewController: TestCellDelegate {
    func downloadCellSelected(test: TestBook) {
        KRProgressHUD.show()
        switch type {
        case 1:
            DownloadClient.shareClient.downloadDataPart1(test: test) { (isDownload) in
                if (isDownload) {
                    DispatchQueue.main.async {
                        self.reloadTableView()
                    }
                }
                KRProgressHUD.dismiss()
            }
            break
        case 2:
            DownloadClient.shareClient.downloadDataPart2(test: test) { (isDownload) in
                if (isDownload) {
                    DispatchQueue.main.async {
                        self.reloadTableView()
                    }
                }
                KRProgressHUD.dismiss()
            }
            break
        case 3:
            DownloadClient.shareClient.downloadPassagePart3(test: test) { (isPassage) in
                if (isPassage) {
                    DownloadClient.shareClient.downloadDataPart3(test: test) { (isDownload) in
                        if (isDownload) {
                            TestManager.updateDataTest(test: test, part: 3)
                            DispatchQueue.main.async {
                                self.reloadTableView()
                            }
                        }
                        KRProgressHUD.dismiss()
                    }
                }
            }
            break
        case 4:
            DownloadClient.shareClient.downloadPassagePart4(test: test) { (isPassage) in
                if (isPassage) {
                    DownloadClient.shareClient.downloadDataPart4(test: test) { (isDownload) in
                        if (isDownload) {
                            TestManager.updateDataTest(test: test, part: 4)
                            DispatchQueue.main.async {
                                self.reloadTableView()
                            }
                        }
                        KRProgressHUD.dismiss()
                    }
                }
            }
            break
        default:
            KRProgressHUD.dismiss()
            break
        }
    }
}
