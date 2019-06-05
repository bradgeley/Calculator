//
//  LogView.swift
//  Calculator
//
//  Created by Bradley Christensen on 5/19/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation
import UIKit

class LogView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLabelConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLabelConstraints()
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func initLabelConstraints() {
        self.addSubview(label)
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        //label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    }
    
    public func updateAndOffset(to text: String, with font: UIFont) {
        let superScrollView = (self.superview as! LogScrollView)
        let oldViewHeight = self.frame.height
        
        label.text = text
        label.font = font
        label.sizeToFit() // Size label to new text
        let screenHeight = superScrollView.frame.height
        let newLabelHeight = label.frame.height
        let newViewHeight = max(screenHeight, (newLabelHeight + 16))
        
        if (newViewHeight != screenHeight) {
            superScrollView.verticalContentOffset(by: newViewHeight - oldViewHeight)
        }
        
        //Update View
        self.setNeedsLayout() // Needed to apply label constraints
        self.constraints.last?.isActive = false //Last constraint should always be the latest width constraint
        self.heightAnchor.constraint(equalToConstant: newViewHeight).isActive = true
    }
    
}
