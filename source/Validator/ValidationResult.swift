//
//  ValidationResult.swift
//  Validator
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

public enum ValidationResult {
    case Success
    case Failure(ValidationError)
}

extension ValidationResult {

    public var isValid:Bool {
        switch self {
        case .Success:
            return true
        case.Failure:
            return false
        }
    }

    public var isInvalid:Bool {
        return !isValid
    }
}
