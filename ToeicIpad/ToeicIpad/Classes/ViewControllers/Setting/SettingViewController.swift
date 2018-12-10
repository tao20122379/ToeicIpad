//
//  SettingViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/10/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

    @IBOutlet weak var settingTableView: UITableView!
    let settingDatas = ["Đánh giá ứng dụng", "Bỏ quảng cáo", "Mua sách"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() -> Void {
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingDatas.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "settingCell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = settingDatas[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}
