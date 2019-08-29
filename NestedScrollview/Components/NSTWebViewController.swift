//
//  NSTWebViewController.swift
//  NestedScrollview
//
//  Created by 陈文琦 on 2018/12/10.
//  Copyright © 2018 vanch. All rights reserved.
//

import UIKit

class NSTWebViewController: NSObject, UITableViewDataSource, UITableViewDelegate {
    let webView = UIWebView()
    
    override init() {
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never;
        }
        webView.frame = UIScreen.main.bounds
        webView.loadRequest(URLRequest(url: URL(string: "https://wap.baidu.com")!))
    }
    
    //MARK: Table DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return webView.frame.size.height
    }
    
    static let tableViewCellID = "NSTWebViewCellStaticID"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: NSTWebViewController.tableViewCellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: NSTWebViewController.tableViewCellID)
            cell?.selectionStyle = .none
            cell?.contentView.addSubview(webView)
        }
        
        return cell!
    }
}
