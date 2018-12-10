//
//  NSTSegmentView.swift
//  NestedScrollview
//
//  Created by 陈文琦 on 2018/12/10.
//  Copyright © 2018 vanch. All rights reserved.
//

import UIKit

class NSTSegmentView: UIView {
    var selectedIndex : Int {
        get {
            return segmentControl.selectedSegmentIndex
        }
    }
    
    var segmentDidTap : ((_ segmentView : NSTSegmentView) -> ())? = nil
    
    private let segmentControl = UISegmentedControl(items: ["Table", "Web"])

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(didTapSegment), for: .valueChanged)
        self.addSubview(segmentControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        segmentControl.frame = bounds.insetBy(dx: 10, dy: 5)
    }
    
    //MARK: Action Methods
    @objc func didTapSegment() {
        if let block = segmentDidTap {
            block(self)
        }
    }
}
