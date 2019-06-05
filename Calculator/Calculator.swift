//
//  Calculator.swift
//  Calculator
//
//  Created by Bradley Christensen on 5/15/19.
//  Copyright © 2019 Bradley Christensen. All rights reserved.
//

import Foundation

class Calculator {
    
    
/* * * * * * * * * * * */
/* Supported Buttons  */
/* * * * * * * * * * */
    
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
        public var value = ""
        public var containsDigits = false //Used to keep track of certain special cases logic
        
        init() {}
        
        init (value: String) {
            self.value = value
        }
        
        public var isInfinity: Bool {
            return self.value == NumberFormatter().positiveInfinitySymbol
                || self.value == NumberFormatter().negativeInfinitySymbol
        }
        
        public var isNaN: Bool {
            if (self.value.contains("-")) {
                return self.value.split(separator: "-")[0] == NumberFormatter().notANumberSymbol
            }
            return self.value == NumberFormatter().notANumberSymbol
        }
    }
    
    
/* * * * * * * * * * */
/* Equation Struct  */
/* * * * * * * * * */
    
    private struct Equation {
        
        init() {}
        
        init(firstNumber: Number) {
            self.addNumber(num: firstNumber)
        }
        
        public var numberList = [Number]()
        public var operatorList = [Operator]()
        public var answer = Number()
        public var onlyNumberIsAnswerFromLastEquation: Bool = false //Consider calculating this based on the answer from the last equation in the log, instead of keeping track of it myself
        
        public mutating func addNumber(num: Number) {
            numberList += [num]
        }
        
        public var lastNumber: Number? {
            if (numberList.count > 0) {
                return numberList[numberList.count - 1]
            }
            return nil
        }
        
        public mutating func addOperator(op: Operator) {
            operatorList += [op]
        }
        
        public func toString() -> String {
            var result = ""
            for index in 0..<numberList.count {
                result += "(" + addCommas(to: numberList[index]) + ")"
                if (index < operatorList.count) {
                    let Operator = operatorList[index].rawValue
                    result += " " + Operator + " "
                }
            }
            if (answer.value != "") {
                result += " = " + addCommas(to: answer)
            }
            return result
        }
        
        func addCommas(to num: Number) -> String {
            
            //Special Characters exception
            guard (num.containsDigits) else { return num.value }
            
            //Remove commas, if any
            let numWithNoCommas = removeCommas(num: num.value)
            
            //Remove and save sign, if any
            var sign:String = ""
            var numWithNoSign = numWithNoCommas
            if (num.value.contains("-")) {
                sign = "-"
                numWithNoSign = String(numWithNoSign.dropFirst())
            }
            
            //Remove and save decimal data, if any
            let numSplitByDecimal:Array<Substring> = numWithNoSign.split(separator: Character("."), maxSplits: 1, omittingEmptySubsequences: true)
            let numWithNoDecimal:String = String(numSplitByDecimal[0])
            var decimal:String = (num.value.contains(".") ? "." : "") //save to add back later
            if (numSplitByDecimal.count > 1) {
                decimal += String(numSplitByDecimal[1])
            }
            
            //Reverse the num for iteration, initialize the result
            let numBackwards:String = String(numWithNoDecimal.reversed())
            var numWithCommas:String = ""
            var numRemaining = numBackwards
            
            //Iterate through numBackwards, adding each character and comma
            var count = 0
            for char in numBackwards {
                numWithCommas += String(char)
                numRemaining = String(numRemaining.dropFirst())
                count += 1
                
                if (count == 3) {
                    //The following if-statement prevents cases where the number length is multiple of 3 (e.g. ,100,000)
                    if (numRemaining.count >= 1) {
                        numWithCommas += ","
                    }
                    count = 0
                }
            }
            
            //Reverse the String back to normal, and add back the decimal/sign
            return String(sign + String((numWithCommas.reversed() + decimal)))
        }
        
        func removeCommas(num:String) -> String {
            var result = num
            result.removeAll(where: { "," == $0 } )
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
        
        public mutating func replaceLastNumber(with num: Number) {
            numberList.removeLast()
            addNumber(num: num)
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
    
    
/* * * * * * * * * * * */
/* EquationLog Struct */
/* * * * * * * * * * */
    
    private struct EquationLog {
        
        public var log = [Equation]()
        
        public func toString() -> String {
            var result = ""
            for equation in log {
                result += equation.toString() + "\n"
            }
            if (result.last == "\n") { result.removeLast() }
            return result
        }
        
        public mutating func add(equation eq: Equation) {
            log.append(eq)
        }
        
        public mutating func clear() {
            log = [Equation]()
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
    private var currentNumber: Number? {
        return currentEquation.lastNumber
    }    //Always the optional last number in the equation, nil if equation is empty
    private var log: EquationLog
    private var formatter: NumberFormatter = NumberFormatter() //For more accurate/properly-rounded math
    
    
/* * * */
/* API */
/* * * */
    
    init() {
        log = EquationLog()
        formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.maximumFractionDigits = 18 //This is a variable value
        formatter.minimumFractionDigits = 1 //This is a variable value
        formatter.roundingMode = .floor
        formatter.numberStyle = .decimal
    }
    
    public var inputText: String { return self.currentEquation.toString() }
    
    public func buttonPressed(button: Calculator.SupportedButton) {
        switch button {
        case let .Digit(value): digitPressed(digit: value)
        case .Decimal:          decimal()
        case .Equals:           equals()
        case .Divide:           operatorWasClicked(op: .DividedBy)
        case .Add:              operatorWasClicked(op: .Plus)
        case .Subtract:         operatorWasClicked(op: .Minus)
        case .Muliply:          operatorWasClicked(op: .MultipliedBy)
        case .ChangeSign:       changeSign()
        case .Percent:          percent()
        case .Clear:            clear()
        }
    }
    
    public func getLogText() -> String {
        return log.toString()
    }
    
    public var shouldClearAll: Bool {
        if (!currentEquation.isEmpty) {
            if (currentEquation.endsWithOperator) {
                return false
            } else {
                if (currentEquation.lastNumber!.containsDigits || currentEquation.lastNumber!.value.contains(".") || currentEquation.lastNumber!.value.contains("-")) {
                    return false
                }
            }
        }
        return true
    }
    
    
/* * * * * * * * * * * * * */
/* Adding/Editing Numbers */
/* * * * * * * * * * * * */
    
    private func digitPressed(digit: Int) {
        checkIfUserIsTypingANewNumberOrEquation()
        if let value = formatter.number(from: currentNumber!.value)?.doubleValue, value == 0 {
            if (digit == 0 && !currentNumber!.value.contains(".")) {
                return
            } else {
                if (!currentNumber!.value.contains(".")) {
                    currentEquation.removeLastNumber()
                    currentEquation.addNumber(num: Number())
                }
            }
        }
        currentNumber!.value += String(digit)
        currentNumber!.containsDigits = true
    }
    
    private func decimal() {
        checkIfUserIsTypingANewNumberOrEquation()
        if (currentNumber!.value == "" || currentNumber!.value == "-") {
            currentNumber!.value += "0"
            currentNumber?.containsDigits = true
        }
        if (!currentNumber!.value.contains(".")) {
            currentNumber!.value += "."
        }
    }
    
    private func checkIfUserIsTypingANewNumberOrEquation() {
        if (currentEquation.isEmpty || currentEquation.endsWithOperator) {
            currentEquation.addNumber(num: Number())
        }
        
        if (currentEquation.onlyNumberIsAnswerFromLastEquation || currentEquation.lastNumber?.value.rangeOfCharacter(from: CharacterSet.letters) != nil) {
            currentEquation = Equation(firstNumber: Number())
            currentEquation.onlyNumberIsAnswerFromLastEquation = false
        }
    }
    
    
/* * * * * * * * * * * * * * * * * * * */
/* Solving Math When User Hits Equals */
/* * * * * * * * * * * * * * * * * * */
    
    //BUG: Changing sign changes sign of answers in the Log
    
    private func equals() {
        if (!currentEquation.isEmpty) {
            if (currentNumber!.containsDigits && !currentEquation.endsWithOperator) {
                //Do math
                currentEquation.answer = solveCurrentEquation()
                
                //Log answer
                log.add(equation: currentEquation)
                
                //Put answer in a new equation so user can use it for more math
                currentEquation = Equation(firstNumber: Number(value: currentEquation.answer.value))
                currentEquation.onlyNumberIsAnswerFromLastEquation = true //Set to catch when the user wants to type a new number over the last answer
                currentNumber?.containsDigits = true
            }
        }
    }
    
    private func solveCurrentEquation() -> Number {
        //Save data
        let equationCopy = currentEquation
        
        //Solve and collapse currentEquation into one answer at index 0
        recursivelySolve()
        
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
        guard (!lhs.isNaN && !rhs.isNaN) else { return Number(value: formatter.notANumberSymbol) }
        let lhsDouble = formatter.number(from: lhs.value)!.doubleValue
        let rhsDouble = formatter.number(from: rhs.value)!.doubleValue
        let result = Number()
        switch op {
        case .Plus: result.value = formatter.string(from: NSNumber(value: lhsDouble + rhsDouble))!
        case .Minus: result.value = formatter.string(from: NSNumber(value: lhsDouble - rhsDouble))!
        case .MultipliedBy: result.value = formatter.string(from: NSNumber(value: lhsDouble * rhsDouble))!
        case .DividedBy: result.value = formatter.string(from: NSNumber(value: lhsDouble / rhsDouble))!
        }
        if (result.value == NumberFormatter().positiveInfinitySymbol || result.value == NumberFormatter().negativeInfinitySymbol || abs(num: result) == NumberFormatter().notANumberSymbol) {
            result.containsDigits = false
        }
        return result
    }
    
    private func abs(num: Number) -> String {
        if num.value.contains("-") {
            return String(num.value.dropFirst())
        }
        return num.value
    }
    
/* * * * * * * * * * * * * * * * */
/* Adding Operators to Equation */
/* * * * * * * * * * * * * * * */
    
    private func operatorWasClicked(op: Operator) {
        if (currentEquation.endsWithOperator) {
            currentEquation.replaceLastOperator(with: op)
        } else {
            if (!currentEquation.isEmpty && currentEquation.lastNumber!.containsDigits) {
                currentEquation.addOperator(op: op)
                currentEquation.onlyNumberIsAnswerFromLastEquation = false
            }
        }
    }
    
    private func changeSign() {
        if (!currentEquation.onlyNumberIsAnswerFromLastEquation) {
            checkIfUserIsTypingANewNumberOrEquation()
        }
        if (currentNumber!.isInfinity) {
            changeSignOfInfinity()
            return
        }
        if (currentEquation.lastNumber!.value.contains("-")) {
            currentEquation.lastNumber!.value.removeFirst()
            if (currentEquation.lastNumber!.value == "") {
                currentEquation.removeLastNumber()
            }
        } else {
            currentEquation.lastNumber!.value = "-" + currentEquation.lastNumber!.value
        }
    }
    
    private func changeSignOfInfinity() {
        if (currentNumber!.value == formatter.positiveInfinitySymbol) {
            currentNumber!.value = formatter.negativeInfinitySymbol
        } else {
            currentNumber!.value = formatter.positiveInfinitySymbol
        }
    }
    
    private func percent() {
        if (!currentEquation.isEmpty && currentEquation.lastNumber!.containsDigits && !currentEquation.endsWithOperator) {
            currentEquation.replaceLastNumber(with: solve(lhs: currentEquation.lastNumber!, op: .DividedBy, rhs: Number(value: "100")))
            currentNumber?.containsDigits = true
        }
    }
    
    
/* * * * * * * * * * * * * * * * * */
/* Clearing Data From Calculator  */
/* * * * * * * * * * * * * * * * */
    
    private func clear() {
        if (!currentEquation.isEmpty) {
            //Clear operator
            if (currentEquation.endsWithOperator) {
                currentEquation.removeLastOperator()
                return
            } else {
                //Clear current number
                if (currentEquation.lastNumber!.containsDigits || currentEquation.lastNumber!.value.contains(".") || currentEquation.lastNumber!.value.contains("-")) {
                    currentEquation.removeLastNumber()
                    currentEquation.onlyNumberIsAnswerFromLastEquation = false
                    return
                }
            }
        }
        //All Clear
        currentEquation = Equation()
        log.clear()
    }
    
}
