//
//  ViewController.swift
//  Calculator
//
//  Created by Bradley Christensen on 5/15/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UIScrollViewDelegate

{
    
/* Constants */
    
    struct Constants {
        static let ButtonFont = "Helvetica"
        static let InputLabelFont = "Helvetica"
        static let ButtonTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func inputScaledFont() -> UIFont {
        let frameSize = inputScrollView!.frame.height - 16
        let fontSize = frameSize / 2
        return UIFontMetrics.init(forTextStyle: .body).scaledFont(for: UIFont(name: Constants.InputLabelFont, size: fontSize)!)
    }
    
    private func buttonScaledFont() -> UIFont {
        let unscaledFontSize: CGFloat = ButtonsToFormat[0].frame.height / 3
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: Constants.ButtonFont, size: unscaledFontSize)!)
    }
   
    
/* IBOutlets */

    @IBOutlet var ButtonsToFormat: [UIButton]!
    @IBOutlet weak var LogScrollView: UIScrollView!
    @IBOutlet weak var LogLabel: UILabel!
    @IBOutlet weak var inputScrollView: InputScrollView!
    
    
/* Variables */
    
    private var calculator: Calculator?
    
    
/* User Interaction Functions */
    
    @IBAction func CalculatorButtonPressed(_ sender: UIButton) {
        let pressedButton = getButton(from: sender.tag)
        
        if (pressedButton == nil) {
            print("Button not supported")
        } else {
            calculator!.buttonPressed(button: pressedButton!)
            updateViewFromModel()
        }
    }
    
    private func getButton(from tag: Int) -> Calculator.SupportedButton? {
        var pressedButton: Calculator.SupportedButton?
        
        //Number
        if (tag >= 0 && tag <= 9) {
            pressedButton = .Number(tag)
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
        case 17: pressedButton = .Percent
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
        setButtonFont(to: buttonScaledFont())
        inputScrollView.update(text: calculator!.inputText, font: inputScaledFont())
    }
    
    private func configureCalculatorButtons() {
        for button in ButtonsToFormat {
            button.titleLabel?.adjustsFontSizeToFitWidth = true //Prevents button text from not fitting container
            button.setTitleColor(Constants.ButtonTextColor, for: .normal)
        }
    }
    
    private func setButtonFont(to font: UIFont) {
        for button in ButtonsToFormat {
            button.titleLabel?.font = font
        }
    }
    
    private func updateViewFromModel() {
        inputScrollView!.update(text: calculator!.inputText, font: inputScaledFont())
    }
    
    
/* Reformatting Cases: */
    
    //BUG: Reformatting from portrait to landscape sometimes has unwanted offset values for the scroll view content
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setButtonFont(to: buttonScaledFont())
        inputScrollView.update(text: calculator!.inputText, font: inputScaledFont())
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setButtonFont(to: buttonScaledFont())
        inputScrollView.update(text: calculator!.inputText, font: inputScaledFont())
    }
    
}

