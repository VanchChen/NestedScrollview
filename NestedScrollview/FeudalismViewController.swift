//
//  FeudalismViewController.swift
//  NestedScrollview
//
//  Created by 陈文琦 on 2018/12/7.
//  Copyright © 2018 vanch. All rights reserved.
//

import UIKit

let SafeZone = 0.5 as CGFloat

class FeudalismViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    let segmentView = NSTSegmentView()
    
    let tableSource = NSTTableViewController()
    let webSource = NSTWebViewController()
    
    //MARK: Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "分而治之"
        
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never;
        }
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        //disable VerticalScrollIndicator
        webSource.webView.scrollView.delegate = self
        
        segmentView.segmentDidTap = { [weak self] (segmentView) in
            guard let strongSelf = self else {
                return
            }
            
            if segmentView.selectedIndex == 1 {
                //Web set frame
                strongSelf.webSource.webView.frame = CGRect(x: 0, y: 0, width: strongSelf.tableView.bounds.size.width, height: strongSelf.tableView.bounds.size.height - NSTSegmentHeight);
                strongSelf.webSource.webView.scrollView.isScrollEnabled = false
            }
            
            strongSelf.tableView.reloadData()
            
            if segmentView.selectedIndex == 0 {
                strongSelf.tableView.isScrollEnabled = true;
                strongSelf.tableView.showsVerticalScrollIndicator = true
            } else {
                strongSelf.scrollViewDidEndScroll(strongSelf.tableView);
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    //MARK: Scroll Delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            scrollViewDidEndScroll(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if segmentView.selectedIndex == 0 {
            return
        }
        
        let webScrollView = webSource.webView.scrollView
        
        let anchor = NSTHeaderHeight
        let offset = scrollView.contentOffset.y
        
        if scrollView == tableView {
            //outside
            if abs(offset - anchor) > SafeZone {
                //double compare strategy
                if offset > anchor {
                    tableView.setContentOffset(CGPoint(x: 0, y: anchor), animated: false)
                    webScrollView.setContentOffset(CGPoint(x: 0, y: webScrollView.contentOffset.y + offset - anchor), animated: false)
                } else if offset < anchor {
                    webScrollView.setContentOffset(CGPoint.zero, animated: false)
                }
            }
        } else {
            //inside
            if abs(offset) > SafeZone {
                //double compare strategy
                if offset > 0 {
                    // keep offset in zone
                    let scrollOffset = min(tableView.contentOffset.y + offset, anchor)
                    tableView.setContentOffset(CGPoint(x: 0, y: scrollOffset), animated: false)
                } else if offset < 0 {
                    // keep offset in zone
                    let scrollOffset = max(tableView.contentOffset.y + offset, 0)
                    tableView.setContentOffset(CGPoint(x: 0, y: scrollOffset), animated: false)
                    webScrollView.setContentOffset(CGPoint.zero, animated: false)
                }
            }
        }
    }
    
    func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        if segmentView.selectedIndex == 0 {
            return
        }
        
        let webScrollView = webSource.webView.scrollView
        
        let anchor = NSTHeaderHeight
        let offset = scrollView.contentOffset.y
        
        var outsideScrollEnable = true
        if scrollView == tableView {
            if abs(offset - anchor) < SafeZone &&
                webScrollView.contentOffset.y > 0 {
                outsideScrollEnable = false
            } else {
                outsideScrollEnable = true
            }
        } else {
            if abs(offset) < SafeZone &&
                tableView.contentOffset.y < anchor {
                outsideScrollEnable = true
            } else {
                outsideScrollEnable = false
            }
        }
        
        tableView.isScrollEnabled = outsideScrollEnable
        tableView.showsVerticalScrollIndicator = outsideScrollEnable
        webScrollView.isScrollEnabled = !outsideScrollEnable
        webScrollView.showsVerticalScrollIndicator = !outsideScrollEnable
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
        if section == 1 {
            return NSTSegmentHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return segmentView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return NSTHeaderHeight
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
