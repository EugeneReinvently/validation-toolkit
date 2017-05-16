//
//  ValidationResultTests.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 17/09/2016.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationToolkit

class ValidationResultTests: XCTestCase {

    func testIsValid() {
        XCTAssertTrue(ValidationResult.valid.isValid)
        XCTAssertFalse(ValidationResult.valid.isInvalid)
    }
    
    func testIsInvalid() {
        
        XCTAssertTrue(ValidationResult.invalid(TestError.InvalidInput).isInvalid)
        XCTAssertFalse(ValidationResult.invalid(TestError.InvalidInput).isValid)
    }
    
    func testResultError() {
        
        XCTAssertTrue(ValidationResult.invalid(TestError.InvalidInput).error != nil)
        XCTAssertTrue(ValidationResult.valid.error == nil)
    }
}

fileprivate enum TestError: Error {
    case InvalidInput
}
