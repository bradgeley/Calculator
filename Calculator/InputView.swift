//
//  InputView.swift
//  Calculator
//
//  Created by Bradley Christensen on 5/19/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation
import UIKit

class InputView: UIView {
    
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
        label.numberOfLines = 1
        label.textAlignment = .right
        label.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func initLabelConstraints() {
        self.addSubview(label)
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    }
    
    public func updateAndOffset(to text: String, with font: UIFont) {
        let superScrollView = (self.superview as! InputScrollView)
        let oldViewWidth = self.frame.width
        
        label.text = text
        label.font = font
        label.sizeToFit() // Size label to new text
        let screenWidth = superScrollView.frame.width
        let newLabelWidth = label.frame.width
        let newViewWidth = max(screenWidth, (newLabelWidth + 16))
        
        if (newViewWidth != screenWidth) {
            superScrollView.horizontalContentOffset(by: newViewWidth - oldViewWidth)
        }
        
        //Update View
        self.setNeedsLayout() // Needed to apply label constraints
        self.constraints.last?.isActive = false //Last constraint should always be the latest width constraint
        self.widthAnchor.constraint(equalToConstant: newViewWidth).isActive = true
    }
    
}
