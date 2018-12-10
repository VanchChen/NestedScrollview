//
//  FeudalismViewController.swift
//  NestedScrollview
//
//  Created by 陈文琦 on 2018/12/7.
//  Copyright © 2018 vanch. All rights reserved.
//

import UIKit

class FeudalismViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    let segmentView = NSTSegmentView()
    
    let tableSource = NSTTableViewController()
    let webSource = NSTWebViewController()
    
    //MARK: Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "分而治之"
        
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        segmentView.segmentDidTap = { [weak self] (segmentView) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableView.reloadData()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    //MARK: Table DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        var num = 1
        
        if segmentView.selectedIndex == 0 {
            num += tableSource.numberOfSections(in: tableView)
        } else {
            num += webSource.numberOfSections(in: tableView)
        }
        
        return num
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if segmentView.selectedIndex == 0 {
            return tableSource.tableView(_:tableView, numberOfRowsInSection:section)
        }
        
        return webSource.tableView(_:tableView, numberOfRowsInSection:section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return segmentView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }
        
        if segmentView.selectedIndex == 0 {
            return tableSource.tableView(_:tableView, heightForRowAt:indexPath)
        }
        
        return webSource.tableView(_:tableView, heightForRowAt:indexPath)
    }
    
    static let tableViewCellID = "FeudalismTableViewCellStaticID"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: FeudalismViewController.tableViewCellID)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: FeudalismViewController.tableViewCellID)
                cell?.selectionStyle = .none
            }
            
            cell!.textLabel?.text = "I worship Feudalism."
            
            return cell!
        }
        
        if segmentView.selectedIndex == 0 {
            return tableSource.tableView(_:tableView, cellForRowAt: indexPath)
        }
        
        return webSource.tableView(_:tableView, cellForRowAt: indexPath)
    }
}
