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
        
        //Numbers       //Button Tag
        case Digit(Int) //0-9
        case Decimal    //10
        
        //Operators
        case Equals     //11
        case Divide     //12
        case Add        //13
        case Subtract   //14
        case Muliply    //15
        case ChangeSign //16
        case Percent    //17
        case Clear      //18
        
    }
    
    private class Number {
        var value: String = ""
    }
    
    private struct Equation {
        public var numberList = [Number]()
        public var operatorList = [Operator]()
        public var answer = Number()
        public var onlyNumberIsAnswerFromLastEquation: Bool = false //Consider calculating this based on the answer from the last equation in the log, instead of keeping track of it myself
        
        mutating func addNumber(num: Number) {
            numberList += [num]
        }
        
        mutating func addOperator(op: Operator) {
            operatorList += [op]
        }
        
        func toString() -> String {
            var result = ""
            for index in 0..<numberList.count {
                result += numberList[index].value
                if (numberList.count != index) {
                    result += " "
                }
                if (index < operatorList.count) {
                    result += operatorList[index].rawValue
                    if (operatorList.count != index) {
                        result += " "
                    }
                }
            }
            if (answer.value != "") {
                result += " = " + answer.value
            }
            return result
        }
        
        public var isEmpty: Bool {
            return (numberList.isEmpty)
        }
        
        public var endsWithOperator: Bool {
            return (numberList.count != 0 && operatorList.count == numberList.count)
        }
        
        public mutating func replaceLastOperator(with op: Operator) {
            operatorList.removeLast()
            addOperator(op: op)
        }
        
        var lastNumber: Number {
            return numberList[numberList.count - 1]
        }
    }
    
    private enum Operator: String {
        case Plus = "+"
        case Minus = "-"
        case DividedBy = "/"
        case MultipliedBy = "*"
    }
    
    
/* API */ 
    
    //Public vars for view controller to access to update display
    public var inputText: String {
        return self.currentEquation.toString()
    }
    private var currentEquation = Equation()
    private var currentNumber = Number()
    
    public var logText = ""
    
    public init() {
        currentEquation.addNumber(num: currentNumber)
    }
    
    public func buttonPressed(button: Calculator.SupportedButton) {
        switch button {
        case let .Digit(value): digitPressed(digit: value)
        case .Decimal:          decimal()
        case .Equals:           equals()
        case .Divide:           divide()
        case .Add:              add()
        case .Subtract:         subtract()
        case .Muliply:          muliply()
        case .ChangeSign:       changeSign()
        case .Percent:          percent()
        case .Clear:            clear()
        }
    }
    
    private func digitPressed(digit: Int) {
        if (currentEquation.endsWithOperator || currentEquation.onlyNumberIsAnswerFromLastEquation) {
            if (currentEquation.onlyNumberIsAnswerFromLastEquation) {
                currentEquation = Equation()
                currentEquation.onlyNumberIsAnswerFromLastEquation = false
            }
            currentNumber = Number()
            currentEquation.addNumber(num: currentNumber)
        }
        currentNumber.value += String(digit)
    }
    
    private func decimal() {
        if (currentNumber.value == "") {
            currentNumber.value += "0"
        }
        if (!inputText.contains(".")) {
            currentNumber.value += "."
        }
    }
    
    private func equals() {
        //Do math
        currentEquation.answer.value = "Urmomgae"
        
        //Log answer
        if (logText != "") {
            logText += "\n"
        }
        logText += inputText
        currentNumber = currentEquation.answer
        currentEquation = Equation()
        currentEquation.addNumber(num: currentNumber)
        currentEquation.onlyNumberIsAnswerFromLastEquation = true
    }
    
    private func divide() {
        currentEquation.onlyNumberIsAnswerFromLastEquation = false
        if (currentEquation.endsWithOperator) {
            currentEquation.replaceLastOperator(with: Operator.DividedBy)
        } else {
            currentEquation.addOperator(op: Operator.DividedBy)
        }
    }
    
    private func add() {
        currentEquation.onlyNumberIsAnswerFromLastEquation = false
        if (currentEquation.endsWithOperator) {
            currentEquation.replaceLastOperator(with: Operator.Plus)
        } else {
            currentEquation.addOperator(op: Operator.Plus)
        }
    }
    
    private func subtract() {
        currentEquation.onlyNumberIsAnswerFromLastEquation = false
        if (currentEquation.endsWithOperator) {
            currentEquation.replaceLastOperator(with: Operator.Minus)
        } else {
            currentEquation.addOperator(op: Operator.Minus)
        }
    }
    
    private func muliply() {
        currentEquation.onlyNumberIsAnswerFromLastEquation = false
        if (currentEquation.endsWithOperator) {
            currentEquation.replaceLastOperator(with: Operator.MultipliedBy)
        } else {
            currentEquation.addOperator(op: Operator.MultipliedBy)
        }
    }
    
    private func changeSign() {
        if (currentEquation.endsWithOperator) {
            currentNumber = Number()
            currentNumber.value += "-"
            currentEquation.addNumber(num: currentNumber)
        } else {
            if (currentNumber.value.contains("-")) {
                currentNumber.value.removeFirst()
            } else {
                currentNumber.value = "-" + currentNumber.value
            }
        }
    }
    
    private func percent() {
        
    }
    
    private func clear() {
        currentEquation = Equation()
        logText = ""
    }

    
}
