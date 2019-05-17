//
//  LogView.swift
//  Calculator
//
//  Created by Bradley Christensen on 5/16/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation
import UIKit

class CalculatorLogView: UIView {
    
    public lazy var logLabel: UILabel = {
        let logLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        logLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        logLabel.text = "Custom View"
        logLabel.textAlignment = .center
        return logLabel
    }()
    
    public var logView: UIView = {
        let logView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        logView.backgroundColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 0.5)
        logView.layer.shadowColor = UIColor.gray.cgColor
        logView.layer.shadowOffset = CGSize(width: 0, height: 10)
        logView.layer.shadowOpacity = 1
        logView.layer.shadowRadius = 5
        return logView
    }()
    
    
    /* Inits */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSettings()
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettings()
        setupView()
    }
    
    
    /* Private Functions */
    
    private func initSettings() {
        isUserInteractionEnabled = false
    }
    
    private func setupView() {
        backgroundColor = .red
        logView.addSubview(logLabel)
        addSubview(logView)
    }
    
    
}
