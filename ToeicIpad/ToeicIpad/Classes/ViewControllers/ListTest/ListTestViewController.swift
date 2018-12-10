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
    
    var type: PartType?
    var listTests = TestManager.getAllTests()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Test"
        initUI()
        if (UserDefaults.standard.bool(forKey: Global.IS_FIRST_LOGIN)){
            initData()
        }
    }
    
    func initUI() -> Void {
        listTestTableView.delegate = self
        listTestTableView.dataSource = self
        listTestTableView.register(UINib(nibName: "TestCell", bundle: nil), forCellReuseIdentifier: "testCell")
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
        switch type?.rawValue {
        case PartType.part1.rawValue:
            cell.downloadBtn.isHidden = testData.isDataPart1
            break
        case PartType.part2.rawValue:
            cell.downloadBtn.isHidden = testData.isDataPart2
            break
        case PartType.part3.rawValue:
            cell.downloadBtn.isHidden = testData.isDataPart3
            break
        case PartType.part4.rawValue:
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
        switch type?.rawValue {
        case PartType.part1.rawValue:
            let part1VC = Part1ViewController(nibName: "Part1ViewController", bundle: nil)
            self.navigationController?.pushViewController(part1VC, animated: true)
            break
        case PartType.part2.rawValue:
            let part2VC = Part2ViewController(nibName: "Part2ViewController", bundle: nil)
            self.navigationController?.pushViewController(part2VC, animated: true)
            break
        case PartType.part3.rawValue:
            let part3VC = Part3ViewController(nibName: "Part3ViewController", bundle: nil)
            self.navigationController?.pushViewController(part3VC, animated: true)
            break
        case PartType.part4.rawValue:
            let part4VC = Part4ViewController(nibName: "Part4ViewController", bundle: nil)
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
        switch type?.rawValue {
        case PartType.part1.rawValue:
            DownloadClient.shareClient.downloadDataPart1(test_id: String(format: "%d", test.test_id)) { (isDownload) in
                if (isDownload) {
                    DispatchQueue.main.async {
                        TestManager.updateDataTest(test: test, part: 1)
                        self.reloadTableView()
                    }
                }
                KRProgressHUD.dismiss()
            }
            break
        case PartType.part2.rawValue:
            DownloadClient.shareClient.downloadDataPart2(test_id: String(format: "%d", test.test_id)) { (isDownload) in
                if (isDownload) {
                    DispatchQueue.main.async {
                        TestManager.updateDataTest(test: test, part: 2)
                        self.reloadTableView()
                    }
                }
                KRProgressHUD.dismiss()
            }
            break
        case PartType.part3.rawValue:
            DownloadClient.shareClient.downloadPassagePart3(test_id: String(format: "%d", test.test_id)) { (isDownload) in
                if (isDownload) {
                    DispatchQueue.main.async {
                        TestManager.updateDataTest(test: test, part: 3)
                        self.reloadTableView()
                    }
                }
                KRProgressHUD.dismiss()
            }
            break
        case PartType.part4.rawValue:
            DownloadClient.shareClient.downloadPassagePart4(test_id: String(format: "%d", test.test_id)) { (isDownload) in
                if (isDownload) {
                    DispatchQueue.main.async {
                        TestManager.updateDataTest(test: test, part: 4)
                        self.reloadTableView()
                    }
                }
                KRProgressHUD.dismiss()
            }
            break
        default:
            KRProgressHUD.dismiss()

            break
        }
    }
}
