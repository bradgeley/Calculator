//
//  Calculator.swift
//  Calculator
//
//  Created by Bradley Christensen on 5/15/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation

class Calculator {
    
    
/* * * * * * * * * * */
/* Supported Buttons */
/* * * * * * * * * */
    
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
    
    
/* * * * * * * * */
/* Number Class */
/* * * * * * * */
    
    private class Number { //Should remain a class so that the currentNumber is passed by reference
        var value = ""
        var containsDigits = false //Used to keep track of certain special cases logic
        
        init() {
            
        }
        
        init (value: String) {
            self.value = value
        }
    }
    
    
/* * * * * * * * * */
/* Equation Struct */
/* * * * * * * * * */
    
    private struct Equation {
        public var numberList = [Number]()
        public var operatorList = [Operator]()
        public var answer = Number()
        public var onlyNumberIsAnswerFromLastEquation: Bool = false //Consider calculating this based on the answer from the last equation in the log, instead of keeping track of it myself
        
        public mutating func addNumber(num: Number) {
            numberList += [num]
        }
        
        public mutating func addOperator(op: Operator) {
            operatorList += [op]
        }
        
        public func toString() -> String {
            var result = ""
            for index in 0..<numberList.count {
                result += "(" + numberList[index].value + ")"
                if (index < operatorList.count) {
                    let Operator = operatorList[index].rawValue
                    result += " " + Operator + " "
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
        
        public var containsMultiplication: Bool {
            for op in operatorList {
                if op == .MultipliedBy || op == .DividedBy {
                    return true
                }
            }
            return false
        }
        
        public var endsWithOperator: Bool {
            return (numberList.count != 0 && operatorList.count == numberList.count)
        }
        
        public mutating func replaceLastOperator(with op: Operator) {
            operatorList.removeLast()
            addOperator(op: op)
        }
        
        public mutating func removeLastNumber() {
            if (numberList.count > 0) {
                numberList.removeLast()
            }
        }
        
        public mutating func removeLastOperator() {
            if (operatorList.count > 0) {
                operatorList.removeLast()
            }
        }
    }
    
    
/* * * * * * * * * * * * */
/* Operator Enumeration */
/* * * * * * * * * * * */
    
    private enum Operator: String {
        case Plus = "+"
        case Minus = "-"
        case DividedBy = "/"
        case MultipliedBy = "*"
    }
    
    
/* * * * * * * * * * * * * * */
/* Private Global Variables */
/* * * * * * * * * * * * * */
    
    private var currentEquation = Equation()
    private var currentNumber = Number()      //Always the last number in the equation
    
    
/* * * */
/* API */
/* * * */
    
    public var inputText: String { return self.currentEquation.toString() }
    public var logText = "" //STUB
    
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
    
    
/* * * * * * * * * * * * * */
/* Adding/Editing Numbers */
/* * * * * * * * * * * * */
    
    private func digitPressed(digit: Int) {
        checkIfUserIsTypingANewNumberOrEquation()
        currentNumber.value += String(digit)
        currentNumber.containsDigits = true
    }
    
    private func decimal() {
        checkIfUserIsTypingANewNumberOrEquation()
        if (currentNumber.value == "") {
            currentNumber.value += "0"
        }
        if (!currentNumber.value.contains(".")) {
            currentNumber.value += "."
        }
    }
    
    private func checkIfUserIsTypingANewNumberOrEquation() {
        if (currentEquation.isEmpty) {
            currentNumber = Number()
            currentEquation.addNumber(num: currentNumber)
        }
        if (currentEquation.endsWithOperator || currentEquation.onlyNumberIsAnswerFromLastEquation) {
            if (currentEquation.onlyNumberIsAnswerFromLastEquation) {
                currentEquation = Equation()
                currentEquation.onlyNumberIsAnswerFromLastEquation = false
            }
            currentNumber = Number()
            currentEquation.addNumber(num: currentNumber)
        }
    }
    
    
/* * * * * * * * * * * * * * * * * * * */
/* Solving Math When User Hits Equals */
/* * * * * * * * * * * * * * * * * * */

    private func equals() {
        if (currentNumber.containsDigits && currentEquation.endsWithOperator == false) {
            //Do math
            currentEquation.answer = solveCurrentEquation()
            
            //Log answer
            if (logText != "") {
                logText += "\n"
            }
            logText += inputText
            
            //
            currentNumber = currentEquation.answer
            currentEquation = Equation()
            currentEquation.addNumber(num: currentNumber)
            currentEquation.onlyNumberIsAnswerFromLastEquation = true
        }
    }
    
    private func solveCurrentEquation() -> Number {
        //Save data
        let equationCopy = currentEquation
        
        //Solve and collapse currentEquation into one answer at index 0
        recursivelySolve()
        //TODO: Consider changing to (add to the struct for Equation, not Calculator class)
        //currentEquation.recursivelySolve()
        
        //Save result
        let result = currentEquation.numberList[0]
        result.containsDigits = true //Helps with logic so user can make answer negative after the answer displays
        
        //Put old equation back for displaying purposes
        currentEquation = equationCopy
        return result
    }
    
    private func recursivelySolve() {
        if (currentEquation.operatorList.count == 0) {
            return
        }
        for index in 0..<currentEquation.operatorList.count {
            let op = currentEquation.operatorList[index]
            if (op == .DividedBy || op == .MultipliedBy || !currentEquation.containsMultiplication) {
                let lhs = currentEquation.numberList[index]
                let rhs = currentEquation.numberList[index + 1]
                let result = solve(lhs: lhs, op: op, rhs: rhs)
                currentEquation.numberList[index] = result
                currentEquation.numberList.remove(at: index + 1)
                currentEquation.operatorList.remove(at: index)
                break
            }
        }
        recursivelySolve()
    }
    
    private func solve(lhs: Number, op: Operator, rhs: Number) -> Number {
        let lhsDouble = Double(lhs.value)
        let rhsDouble = Double(rhs.value)
        if lhsDouble != nil, rhsDouble != nil {
            switch op {
            case .Plus: return Number(value: String(lhsDouble! + rhsDouble!))
            case .Minus: return Number(value: String(lhsDouble! - rhsDouble!))
            case .MultipliedBy: return Number(value: String(lhsDouble! * rhsDouble!))
            case .DividedBy: return Number(value: String(lhsDouble! / rhsDouble!))
            }
        }
        return Number()
    }
    
/* * * * * * * * * * * * * * *  */
/* Adding Operators to Equation */
/* * * * * * * * * * * * * * * */
    
    private func divide() {
        operatorWasClicked(op: Operator.DividedBy)
    }
    
    private func add() {
        operatorWasClicked(op: Operator.Plus)
    }
    
    private func subtract() {
        operatorWasClicked(op: Operator.Minus)
    }
    
    private func muliply() {
        operatorWasClicked(op: Operator.MultipliedBy)
    }
    
    private func operatorWasClicked(op: Operator) {
        if (currentEquation.endsWithOperator) {
            currentEquation.replaceLastOperator(with: op)
        } else {
            if (currentNumber.containsDigits) {
                currentEquation.addOperator(op: op)
                currentEquation.onlyNumberIsAnswerFromLastEquation = false
            }
        }
    }
    
    private func changeSign() {
        checkIfUserIsTypingANewNumberOrEquation()
        if (currentNumber.value.contains("-")) {
            currentNumber.value.removeFirst()
            if (currentNumber.value == "") {
                currentEquation.removeLastNumber()
                let last = currentEquation.numberList.count - 1
                currentNumber = currentEquation.numberList[last]
            }
        } else {
            currentNumber.value = "-" + currentNumber.value
        }
    }
    
    private func percent() {
        if (currentNumber.containsDigits) {
            divide()
            digitPressed(digit: 1)
            digitPressed(digit: 0)
            digitPressed(digit: 0)
        }
    }
    
    
/* * * * * * * * * * * * * * * * */
/* Clearing Data From Calculator */
/* * * * * * * * * * * * * * * * */
    
    private func clear() {
        if (currentEquation.endsWithOperator) {
            currentEquation.removeLastOperator()
        } else {
            //All Clear
            currentEquation = Equation()
            logText = ""
        }
    }

    
}
