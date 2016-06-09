//
//  Types.swift
//  Jay
//
//  Created by Honza Dvorsky on 2/17/16.
//  Copyright © 2016 Honza Dvorsky. All rights reserved.
//

public typealias JChar = UTF8.CodeUnit

public enum JSON {
    public enum Number {
        case integer(Int)
        case unsignedInteger(UInt)
        case double(Double)
    }
    case object([String: JSON])
    case array([JSON])
    case number(JSON.Number)
    case string(String)
    case boolean(Bool)
    case null
}

//
// TODO: refactor with
// https://github.com/apple/swift-evolution/blob/master/proposals/0080-failable-numeric-initializers.md
//

extension Int {
    public init?(_ number: JSON.Number) {
        switch number {
        case let .integer(value)                                         : self.init(value)
        case let .unsignedInteger(value) where value <= UInt(Int.max)    : self.init(value)
        case let .double(value)          where value <= Double(Int32.max): self.init(value)
        default: return nil
        }
    }
}

extension UInt {
    public init?(_ number: JSON.Number) {
        switch number {
        case let .integer(value)         where value > 0                  : self.init(value)
        case let .unsignedInteger(value)                                  : self.init(value)
        case let .double(value)          where value <= Double(UInt32.max): self.init(value)
        default: return nil
        }
    }
}

extension Double {
    public init(_ number: JSON.Number) {
        switch number {
        case let .integer(value)        : self.init(value)
        case let .unsignedInteger(value): self.init(value)
        case let .double(value)         : self.init(value)
        }
    }
}

