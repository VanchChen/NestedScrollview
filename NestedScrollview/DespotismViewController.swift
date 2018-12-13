//
//  DespotismViewController.swift
//  NestedScrollview
//
//  Created by 陈文琦 on 2018/12/7.
//  Copyright © 2018 vanch. All rights reserved.
//

import UIKit

class DespotismViewController: UIViewController, UIScrollViewDelegate {
    let scrollView = UIScrollView()
    
    let headLabel = UILabel()
    let segmentView = NSTSegmentView()
    
    let tableSource = NSTTableViewController()
    let webSource = NSTWebViewController()
    
    var currentScrollView : UIScrollView? = nil
    var currentScrollDelegate : UIScrollViewDelegate? = nil
    
    //保持观察者生命周期
    var observer : NSKeyValueObservation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "中央集权"
        
        scrollView.delegate = self
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
        segmentView.frame = CGRect(x: 0, y: max(200, scrollView.contentOffset.y), width: scrollView.frame.size.width, height: 44)
        
        if currentScrollView != nil {
            currentScrollView?.frame = CGRect(x: 0, y: segmentView.frame.maxY, width: scrollView.frame.size.width, height: view.bounds.size.height - 44)
        }
    }
    
    func reloadScrollView() {
        let contentScrollView = segmentView.selectedIndex == 0 ? tableSource.tableView : webSource.webView.scrollView
        
        if currentScrollView == contentScrollView {
            return
        }
        
        if currentScrollView != nil {
            currentScrollView!.removeFromSuperview()
            
            //Remove KVO
            observer?.invalidate()
            observer = nil
        }
        
        contentScrollView.isScrollEnabled = false
        scrollView.addSubview(contentScrollView)
        
        //Add KVO
        observer = contentScrollView.observe(\.contentSize, options: [.new, .initial]) {[weak self] object, change in
            guard let strongSelf = self else {
                return
            }
            let closureScrollView = object as UIScrollView
            
            strongSelf.scrollView.contentSize = CGSize(width: 0, height: 244 + closureScrollView.contentSize.height)
        }
        
        typealias ClosureType = @convention(c) (AnyObject, Selector) -> AnyObject
        let imp = class_getMethodImplementation(UIScrollView.self, #selector(getter: UIScrollView.delegate))
        let delegateFunc : ClosureType = unsafeBitCast(imp, to: ClosureType.self)
        currentScrollDelegate = delegateFunc(contentScrollView, #selector(getter: UIScrollView.delegate)) as? UIScrollViewDelegate
        
        currentScrollView = contentScrollView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        var floatOffset = scrollView.contentOffset
        floatOffset.y -= 244
        floatOffset.y = max(floatOffset.y, 0)
        
        if currentScrollView?.contentOffset.equalTo(floatOffset) == false {
            currentScrollView?.setContentOffset(floatOffset, animated: false)
        }
//        else if currentScrollDelegate != nil {
//            currentScrollDelegate!.scrollViewDidScroll?(currentScrollView!)
//        }
    }
    /*
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if currentScrollDelegate != nil {
            currentScrollDelegate!.scrollViewWillBeginDragging?(currentScrollView!)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if currentScrollDelegate != nil {
            currentScrollDelegate!.scrollViewWillEndDragging?(currentScrollView!, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if currentScrollDelegate != nil {
            currentScrollDelegate!.scrollViewDidEndDragging?(currentScrollView!, willDecelerate: decelerate)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if currentScrollDelegate != nil {
            currentScrollDelegate!.scrollViewWillBeginDecelerating?(currentScrollView!)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if currentScrollDelegate != nil {
            currentScrollDelegate!.scrollViewDidEndDecelerating?(currentScrollView!)
        }
    }
 */
}
