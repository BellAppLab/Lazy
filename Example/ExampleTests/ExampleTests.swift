//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Bell App Lab on 21.12.17.
//  Copyright © 2017 Bell App Lab. All rights reserved.
//

import XCTest


class TestClass
{
    let lazyString = §{
        return "testString"
    }
    
    let lazyDouble: Lazy<Double> = Lazy {
        return 0.0
    }
    
    let lazyArray = Lazy {
        return ["one", "two", "three"]
    }
}


class ExampleTests: XCTestCase
{
    let testClass = TestClass()
    
    func testExample() {
        XCTAssertEqual(testClass.lazyString§, "testString", "What is going on here?")
        XCTAssertEqual(testClass.lazyDouble§, 0.0, "What is going on here?")
        XCTAssertEqual(testClass.lazyArray§, ["one", "two", "three"], "What is going on here?")
        
        testClass.lazyDouble §= 1.0
        
        XCTAssertEqual(testClass.lazyDouble§, 1.0, "What is going on here?")
    }
}
