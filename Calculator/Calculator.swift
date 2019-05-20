//
//  Calculator.swift
//  Calculator
//
//  Created by Bradley Christensen on 5/15/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation

class Calculator {
    
    
/* Constants */
    
    // Maybe bad design? The button tags are listed below,
    // which are the same as they are on the storyboard.
    // Fix: The ViewController parses which button to press
    public enum SupportedButton {
        
        //Numbers
        case Number(Int) //Tags 0-9
        case Decimal //10
        
        //Operators
        case Equals //11
        case Divide //12
        case Add //13
        case Subtract //14
        case Muliply //15
        case ChangeSign //16
        case Percent //17
        case Clear //18
        
    }
    
    
/* API */ 
    
    //Public vars for view controller to access to update display
    public var inputText = "0"
    public var logText = "0"
    
    public func buttonPressed(button: Calculator.SupportedButton) {
        switch button {
        case let .Number(value): inputText += String(value)
        case .Clear: inputText = "0"
        default: break
        }
    }
    
}
