//
//  DespotismViewController.swift
//  NestedScrollview
//
//  Created by 陈文琦 on 2018/12/7.
//  Copyright © 2018 vanch. All rights reserved.
//

import UIKit

class DespotismViewController: UIViewController {
    let scrollView = UIScrollView()
    
    let headLabel = UILabel()
    let segmentView = NSTSegmentView()
    
    let tableSource = NSTTableViewController()
    let webSource = NSTWebViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "中央集权"
        
        view.addSubview(scrollView)
        
        headLabel.text = "I worship Despotism."
        scrollView.addSubview(headLabel)
        
        segmentView.segmentDidTap = { [weak self] (segmentView) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.reloadScrollView()
        }
        scrollView.addSubview(segmentView)
        
        self.reloadScrollView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        headLabel.frame = CGRect(x: 15, y: 0, width: scrollView.frame.size.width - 30, height: 200)
        segmentView.frame = CGRect(x: 0, y: 200, width: scrollView.frame.size.width, height: 44)
    }
    
    func reloadScrollView() {
        
    }
}
