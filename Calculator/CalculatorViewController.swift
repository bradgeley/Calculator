//
//  ViewController.swift
//  Calculator
//
//  Created by Bradley Christensen on 5/15/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    struct Constants {
        
        static let OutputFont = "Helvetica"
        static let OutputFontSizeLandscape: CGFloat = 50.0
        static let OutputFontSizePortrait: CGFloat = 30
        
        static let ButtonFont = "Helvetica"
        static let ButtonFontSizeLandscape: CGFloat = 35
        static let ButtonFontSizePortrait: CGFloat = 30
        
    }
    
    
/* IBOutlets */
    
    @IBOutlet var LabelsToFormat: [UILabel]!
    @IBOutlet var ButtonsToFormat: [UIButton]!
    @IBOutlet weak var OutputLabel: UILabel!
    @IBOutlet weak var InputLabel: UILabel!
    @IBOutlet weak var LogView: CalculatorLogView!
    
    
/* Variables */
    
    var output: String? {
        didSet {
            OutputLabel.text = output
            formatLabels()
        }
    }
    
    var input: String? {
        didSet {
            InputLabel.text = input
            formatLabels()
        }
    }
    
    var outputLabelFont: UIFont? {
        return ((UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
              || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight) ?
              UIFont(name: Constants.OutputFont, size: Constants.OutputFontSizeLandscape)
            : UIFont(name: Constants.OutputFont, size: Constants.OutputFontSizePortrait))
    }
    
    var buttonFont: UIFont? {
        return ((UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft
            || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight) ?
                UIFont(name: Constants.ButtonFont, size: Constants.ButtonFontSizeLandscape)
            : UIFont(name: Constants.ButtonFont, size: Constants.ButtonFontSizePortrait))
    }
    
    
/* Private Functions */
    
    private func formatAllText() {
        formatButtons()
        formatLabels()
    }
    
    private func formatButtons() {
        for button in ButtonsToFormat {
            let scaledFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: outputLabelFont!)
            button.titleLabel?.font = scaledFont
        }
    }
    
    private func formatLabels() {
        for label in LabelsToFormat {
            let scaledFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: outputLabelFont!)
            label.font = scaledFont
        }
    }
    
    
/* Override functions */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //formatAllText()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //formatAllText()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //formatAllText()
    }
}

