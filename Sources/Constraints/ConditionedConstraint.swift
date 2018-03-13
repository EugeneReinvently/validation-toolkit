import Foundation

/**
 A data type that links a `Predicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public class ConditionedConstraint<T>: SimpleConstraint<T> {

    private var conditions =  [AnyConstraint<T>]()

    /**
        The number of conditions that must ....
    */
    public var conditionsCount: Int {
        return conditions.count;
    }

    /**
     Create a new `ConditionedConstraint` instance

     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public override init<P>(predicate: P, error: Error) where T == P.InputType, P : Predicate {
        super.init(predicate: predicate, error: error)
    }
    /**
     Create a new `ConditionedConstraint` instance

     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public override init<P>(predicate: P, error: @escaping (T) -> Error) where T == P.InputType, P : Predicate {
        super.init(predicate: predicate, error: error)
    }

    public func append<C:Constraint>(condition:C) where C.InputType == T {
        conditions.append(condition.erase())
    }

    public func append<C:Constraint>(conditions:[C]) where C.InputType == T {
        let constraits = conditions.map { $0.erase() }
        self.conditions.append(contentsOf: constraits)
    }

    /**
     Evaluates the input on the `Predicate`.

     - parameter input: The input to be validated.
     - returns: `.valid` if the input is valid,`.invalid` containing the `Result.Summary` of the failing `Constraint`s otherwise.
     */
    public override func evaluate(with input:T) -> Result {

        if !hasConditions() {
            return super.evaluate(with: input)
        }

        let constraintSet = ConstraintSet(constraints: conditions)
        let result = constraintSet.evaluateAll(input: input)

        if result.isValid {
            return super.evaluate(with: input)
        }

        return result
    }

    private func hasConditions() -> Bool {
        return conditions.count > 0
    }
}
