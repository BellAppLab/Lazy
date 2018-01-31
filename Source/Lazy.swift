//
//  CwlMutex.swift
//  CwlUtils
//
//  Created by Matt Gallagher on 2015/02/03.
//  Copyright © 2015 Matt Gallagher ( http://cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
//  SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
//  IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

fileprivate final class PThreadMutex {
    func sync<R>(execute work: () throws -> R) rethrows -> R {
        unbalancedLock()
        defer { unbalancedUnlock() }
        return try work()
    }
    func trySync<R>(execute work: () throws -> R) rethrows -> R? {
        guard unbalancedTryLock() else { return nil }
        defer { unbalancedUnlock() }
        return try work()
    }
    
    typealias MutexPrimitive = pthread_mutex_t
    
    // Non-recursive "PTHREAD_MUTEX_NORMAL" and recursive "PTHREAD_MUTEX_RECURSIVE" mutex types.
    enum PThreadMutexType {
        case normal
        case recursive
    }
    
    var unsafeMutex = pthread_mutex_t()
    
    /// Default constructs as ".Normal" or ".Recursive" on request.
    init(type: PThreadMutexType = .normal) {
        var attr = pthread_mutexattr_t()
        guard pthread_mutexattr_init(&attr) == 0 else {
            preconditionFailure()
        }
        switch type {
        case .normal:
            pthread_mutexattr_settype(&attr, Int32(PTHREAD_MUTEX_NORMAL))
        case .recursive:
            pthread_mutexattr_settype(&attr, Int32(PTHREAD_MUTEX_RECURSIVE))
        }
        guard pthread_mutex_init(&unsafeMutex, &attr) == 0 else {
            preconditionFailure()
        }
        pthread_mutexattr_destroy(&attr)
    }
    
    deinit {
        pthread_mutex_destroy(&unsafeMutex)
    }
    
    func unbalancedLock() {
        pthread_mutex_lock(&unsafeMutex)
    }
    
    func unbalancedTryLock() -> Bool {
        return pthread_mutex_trylock(&unsafeMutex) == 0
    }
    
    func unbalancedUnlock() {
        pthread_mutex_unlock(&unsafeMutex)
    }
}


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
            let result = PThreadMutex().sync(execute: { [weak self] in self?._value ?? constructor() })
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
