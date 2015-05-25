//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Aye Min Aung on 25/5/15.
//  Copyright (c) 2015 Aye Min Aung. All rights reserved.
//

import Foundation
class CalculatorBrain
{
    
    private enum Op
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init()
    {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    func evaluate() -> Double?
    {
        let (result, remainders) = evaluate(opStack)
        return result
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remaingOps = ops
            let op = remaingOps.removeLast()
            switch op {
                case .Operand(let operand):
                    return (operand, remaingOps)
                case .UnaryOperation(_, let operation):
                    let operandEvaluation = evaluate(remaingOps)
                    if let operand = operandEvaluation.result {
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let op1Evaluation = evaluate(remaingOps)
                    if let operand1 = op1Evaluation.result {
                        let op2Evaliation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaliation.result {
                            return (operation(operand1, operand2), op2Evaliation.remainingOps)
                        }
                    }
            }
        }
        return (nil, ops)
    }
    
    func pushOperand(operand: Double) -> Double?
    {
       opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?
    {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}