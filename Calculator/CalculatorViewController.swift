//
//  ViewController.swift
//  Calculator
//
//  Created by Bradley Christensen on 5/15/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//
//  Version 1.1
//

import UIKit

class CalculatorViewController: UIViewController, UIScrollViewDelegate

{
    
/* Constants */
    
    struct Constants {
        static let ButtonFont = "Helvetica"
        static let InputLabelFont = "Helvetica"
        static let minimumFontSize: CGFloat = 10
        static let ButtonTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func logScaledFont() -> UIFont {
        let frameSize = logScrollView!.frame.height - 16
        var fontSize: CGFloat?
        if (UIDevice.current.orientation.isLandscape) {
            fontSize = frameSize / 7
        } else {
            fontSize = frameSize / 12
        }
        if fontSize! < Constants.minimumFontSize {
            fontSize = Constants.minimumFontSize
        }
        return UIFontMetrics.init(forTextStyle: .body).scaledFont(for: UIFont(name: Constants.InputLabelFont, size: fontSize!)!)
    }
    
    private func inputScaledFont() -> UIFont {
        let frameSize = inputScrollView!.frame.height - 16
        let fontSize = frameSize / 2
        return UIFontMetrics.init(forTextStyle: .body).scaledFont(for: UIFont(name: Constants.InputLabelFont, size: fontSize)!)
    }
    
    private func buttonScaledFont() -> UIFont {
        let unscaledFontSize: CGFloat = buttonsToFormat[0].frame.height / 3
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: Constants.ButtonFont, size: unscaledFontSize)!)
    }
   
    
/* IBOutlets */

    @IBOutlet weak var logScrollView: LogScrollView!
    @IBOutlet weak var inputScrollView: InputScrollView!
    @IBOutlet var buttonsToFormat: [UIButton]!
    @IBOutlet weak var ClearButton: UIButton!
    
    
/* Variables */
    
    private var calculator: Calculator?
    
    
/* User Interaction Functions */
    
    @IBAction func CalculatorButtonPressed(_ sender: UIButton) {
        let pressedButton = getButton(from: sender.tag)
        calculator!.buttonPressed(button: pressedButton!)
        updateViewFromModel()
    }
    
    private func getButton(from tag: Int) -> Calculator.SupportedButton? {
        var pressedButton: Calculator.SupportedButton?
        
        //Number
        if (tag >= 0 && tag <= 9) {
            pressedButton = .Digit(tag)
        }
        //Operator
        switch tag {
        case 10: pressedButton = .Decimal
        case 11: pressedButton = .Equals
        case 12: pressedButton = .Add
        case 13: pressedButton = .Subtract
        case 14: pressedButton = .Muliply
        case 15: pressedButton = .Divide
        case 16: pressedButton = .ChangeSign
        case 17: pressedButton = .Exponent
        case 18: pressedButton = .Clear
        default: break
        }
        return pressedButton
    }
    
    
/* Display functions */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalculatorButtons()
        calculator = Calculator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setAllButtonFont(to: buttonScaledFont())
        updateViewFromModel()
    }
    
    private func configureCalculatorButtons() {
        for button in buttonsToFormat {
            button.titleLabel?.adjustsFontSizeToFitWidth = true //Prevents button text from not fitting container
            button.setTitleColor(Constants.ButtonTextColor, for: .normal)
        }
    }
    
    private func setAllButtonFont(to font: UIFont) {
        for button in buttonsToFormat {
            button.titleLabel?.font = font
        }
    }
    
    private func updateViewFromModel() {
        inputScrollView!.update(text: calculator!.inputText, font: inputScaledFont())
        logScrollView!.update(text: calculator!.getLogText(), font: logScaledFont())
        if (calculator!.shouldClearAll) {
            ClearButton.setTitle("AC", for: .normal)
        } else {
            ClearButton.setTitle("C", for: .normal)
        }
    }
    
    
/* Reformatting Cases: */
    
    //BUG: Reformatting from portrait to landscape sometimes has unwanted offset values for the scroll view content
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setAllButtonFont(to: buttonScaledFont())
        updateViewFromModel()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setAllButtonFont(to: buttonScaledFont())
        updateViewFromModel()
    }
    
}

