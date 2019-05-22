//
//  LogScrollView.swift
//  Calculator
//
//  Created by Bradley Christensen on 5/19/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation
import UIKit

class LogScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLogViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLogViewConstraints()
    }
    
    public let contentView: LogView = {
        let contentView = LogView()
        contentView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private func initLogViewConstraints() {
        self.addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
    }
    
    public func update(text: String, font: UIFont) {
        contentView.updateAndOffset(to: text, with: font)
    }
    
}


extension UIScrollView {
    func verticalContentOffset(by y: CGFloat) {
        let offset = CGPoint(x: self.contentOffset.x, y: self.contentOffset.y + y)
        UIView.animate(withDuration: 0.25, animations: { self.setContentOffset(offset, animated: false) } )
    }
}
