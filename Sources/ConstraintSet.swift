//
//  ConstraintSet.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 15/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 A generic collection of `Constraints` on which an input can be validated on.
 */
public struct ConstraintSet<T> {

    var constraints:[Constraint<T>]
    
    /**
     
    */
    public var conditions = [Constraint<T>]()
    
    /**
     Create a new `ConstraintSet` instance
     */
    public init() {
        constraints = [Constraint<T>]()
    }
    
    /**
     Create a new `ConstraintSet` instance populated with a predefined list of `Constraints`
     
     - parameter constraints: `[Constraint]`
     */
    public init(constraints:[Constraint<T>]) {
        self.constraints = constraints
    }

    /**
     Create a new `ConstraintSet` instance populated with a unsized list of `Constraints`
     
     - parameter constraints: `[Constraint]`
     */
    public init(constraints:Constraint<T>...) {
        self.init(constraints:constraints)
    }
}

extension ConstraintSet {

    /**
     Adds a `Constraint` to the generic collection of constraints.
     
     - parameter constraint: `Constraint`
     */
    public mutating func add(constraint:Constraint<T>) {
        constraints.append(constraint)
    }

    /**
     Adds a `Constraint` to the generic collection of constraints.
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter message: An `Error` that describes why the evaluation has failed.
     */
    public mutating func add<P:Predicate>(predicate:P, error:Error) where P.InputType == T {
        let constraint = Constraint(predicate: predicate, error: error)
        add(constraint: constraint)
    }
}

extension ConstraintSet {

    /**
     Evaluates the input on all `Constraints` until the first fails.
     
     - parameter input: The input to be validated.
     - returns: `.valid` if the input is valid, `.invalid` containing the `Error` registered with the failing `Constraint` otherwise.
     */
    public func evaluateAny(input:T) -> EvaluationResult {
        
        if conditions.count == 0 {
            return forwardEvaluateAny(input: input)
        }
        
        let conditionsSet = ConstraintSet(constraints: conditions);
        let result = conditionsSet.evaluateAny(input:input)
        
        switch result {
        case .valid:
            return forwardEvaluateAny(input: input)
        default:
            return result
        }
    }
    
    private func forwardEvaluateAny(input:T) -> EvaluationResult {
        return constraints.reduce(.valid) { $0.isInvalid ? $0 : $1.evaluate(with: input) }
    }

    /**
     Evaluates the input on all `Constraints in the collection.
     
     - parameter input: The input to be validated.
     - returns: An array of `EvaluationResult` elements, indicating the evaluation result of each `Constraint` in collection.
     */
    public func evaluateAll(input:T) -> [EvaluationResult] {
        if conditions.count == 0 {
            return forwardEvaluateAll(input: input)
        }
    
        let conditionsSet = ConstraintSet(constraints: conditions);
        let results = conditionsSet.evaluateAll(input:input)
        
        if conditionsPassAll(evaluationResults: results) {
            return forwardEvaluateAll(input: input)
        }
        
        return results
    }
    
    private func conditionsPassAll(evaluationResults:[EvaluationResult]) -> Bool {
        return evaluationResults.flatMap { $0.error }.count == 0
    }
    
    private func forwardEvaluateAll(input:T) -> [EvaluationResult] {
        return constraints.map{ $0.evaluate(with:input) }
    }
}
