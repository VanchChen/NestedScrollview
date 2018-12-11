//
//  ColonialismViewController.swift
//  NestedScrollview
//
//  Created by 陈文琦 on 2018/12/7.
//  Copyright © 2018 vanch. All rights reserved.
//

import UIKit

class ColonialismViewController: UIViewController {
    let headLabel = UILabel()
    let segmentView = NSTSegmentView()
    
    let tableSource = NSTTableViewController()
    let webSource = NSTWebViewController()
    
    var currentScrollView : UIScrollView? = nil
    //保持观察者生命周期
    var observer : NSKeyValueObservation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "各自为政"
        
        headLabel.text = "I worship Colonialism."
        
        segmentView.segmentDidTap = { [weak self] (segmentView) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.reloadScrollView()
        }
        
        self.reloadScrollView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = CGRect(x: 15, y: -244, width: view.bounds.size.width - 30, height: 200)
        headLabel.frame = frame
        
        frame = CGRect(x: 0, y: segmentView.frame.origin.y, width: view.bounds.size.width, height: 44)
        segmentView.frame = frame
        
        if currentScrollView != nil {
            currentScrollView!.frame = view.bounds
        }
    }
    
    func reloadScrollView() {
        let scrollView = segmentView.selectedIndex == 0 ? tableSource.tableView : webSource.webView.scrollView
        
        if currentScrollView == scrollView {
            return
        }
        
        headLabel.removeFromSuperview()
        segmentView.removeFromSuperview()
        if currentScrollView != nil {
            currentScrollView!.removeFromSuperview()
            
            //Remove KVO
            observer?.invalidate()
            observer = nil
        }
        
        scrollView.contentInset = UIEdgeInsetsMake(244, 0, 0, 0)
        scrollView.addSubview(headLabel)
        scrollView.addSubview(segmentView)
        view.addSubview(scrollView)
        
        //Add KVO
        observer = scrollView.observe(\.contentOffset, options: [.new, .initial]) {[weak self] object, change in
            guard let strongSelf = self else {
                return
            }
            let closureScrollView = object as UIScrollView
            var segmentFrame = strongSelf.segmentView.frame
            let safeOffsetY = closureScrollView.contentOffset.y + closureScrollView.safeAreaInsets.top
            
            if safeOffsetY < -44 {
                segmentFrame.origin.y = -44
            } else {
                segmentFrame.origin.y = safeOffsetY
            }
            
            strongSelf.segmentView.frame = segmentFrame
        }
        
        currentScrollView = scrollView
    }
}
