//
//  NSTableView.swift
//  NestedScrollview
//
//  Created by 陈文琦 on 2018/12/10.
//  Copyright © 2018 vanch. All rights reserved.
//

import UIKit

class NSTTableViewController : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    
    override init() {
        super.init()
        
        tableView.frame = UIScreen.main.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
    }

    //MARK: Table DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    static let tableViewCellID = "NSTTableViewCellStaticID"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: NSTTableViewController.tableViewCellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: NSTTableViewController.tableViewCellID)
            cell?.selectionStyle = .none
        }
        
        cell!.textLabel?.text = "\(indexPath.row)"
        
        return cell!
    }
}
