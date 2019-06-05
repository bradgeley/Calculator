//
//  InputScrollView.swift
//  Calculator
//
//  Created by Bradley Christensen on 5/19/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation
import UIKit

class InputScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initInputViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initInputViewConstraints()
    }
    
    public let contentView: InputView = {
        let contentView = InputView()
        contentView.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private func initInputViewConstraints() {
        self.addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
    }

    public func update(text: String, font: UIFont) {
        contentView.updateAndOffset(to: text, with: font)
    }
    
}


extension UIScrollView {
    func horizontalContentOffset(by x: CGFloat) {
        let offset = CGPoint(x: self.contentOffset.x + x, y: self.contentOffset.y)
        UIView.animate(withDuration: 0.25, animations: { self.setContentOffset(offset, animated: false) } )
    }
}
