//
//  Lazy.swift
//  Example
//
//  Created by Bell App Lab on 21.12.17.
//  Copyright © 2017 Bell App Lab. All rights reserved.
//

import Foundation


public class Lazy<Value>: CustomStringConvertible, CustomDebugStringConvertible
{
    public init(_ constructor: @escaping () -> Value) {
        self.constructor = constructor
    }
    
    fileprivate var value: Value! {
        get {
            let result = _value ?? constructor()
            _value = result
            return result
        }
        set {
            _value = newValue
        }
    }
    
    private let constructor: () -> Value
    
    private var _value: Value?
    
    public var description: String {
        return debugDescription
    }
    
    public var debugDescription: String {
        if let tempValue = _value {
            return "Lazy<\(type(of: tempValue))>: constructor - \(constructor); value: \(tempValue)"
        }
        return "Lazy: constructor - \(constructor); value: nil"
    }
}


postfix operator §
public postfix func §<T>(lhs: Lazy<T>) -> T {
    return lhs.value
}

infix operator §=
public func §=<T>(lhs: Lazy<T>, rhs: T?) {
    lhs.value = rhs
}
public func §=<T>(lhs: Lazy<T>?, rhs: T?) {
    lhs?.value = rhs
}

prefix operator §
public prefix func §<T>(rhs: @escaping () -> T) -> Lazy<T> {
    return Lazy(rhs)
}
