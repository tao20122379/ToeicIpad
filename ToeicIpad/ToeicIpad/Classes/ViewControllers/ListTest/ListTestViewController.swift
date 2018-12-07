//
//  ListTestViewController.swift
//  ToeicIpad
//
//  Created by DungLM3 on 12/5/18.
//  Copyright © 2018 DungLM3. All rights reserved.
//

import UIKit


class ListTestViewController: BaseViewController {
    
    @IBOutlet weak var listTestTableView: UITableView!
    
    var type: PartType?
    let listBooks = BookManager.getBooks()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Test"
        listTestTableView.delegate = self
        listTestTableView.dataSource = self
    }
    
}

extension ListTestViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "listTest")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "listTest")
        }
        
        cell?.textLabel?.text = listBooks[indexPath.row].book_name
        return cell!
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
            let part3VC = Part34ViewController(nibName: "Part34ViewController", bundle: nil)
            self.navigationController?.pushViewController(part3VC, animated: true)
            break
        case PartType.part4.rawValue:
            let part4VC = Part34ViewController(nibName: "Part34ViewController", bundle: nil)
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
