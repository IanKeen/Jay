//
//  Reader.swift
//  Jay
//
//  Created by Honza Dvorsky on 2/17/16.
//  Copyright © 2016 Honza Dvorsky. All rights reserved.
//

protocol Reader {
    
    var opts: JayOpts { get }
    
    // Returns the currently pointed-at char
    func curr() throws -> JChar

    // Moves cursor to the next char
    mutating func next()
    
    // Returns the `next` next characters, if not enough chars, returns
    // less characters.
    func peek(next: Int) -> [JChar]
    
    // Returns `true` if all characters have been read 
    func isDone() -> Bool
}

extension Reader {
    
    mutating func readNext(next: Int) throws -> [JChar] {
        try self.ensureNotDone()
        var buff = [JChar]()
        while buff.count < next {
            buff.append(try self.curr())
            try self.nextAndCheckNotDone()
        }
        return buff
    }
    
    func isDoneAndFragmentsAllowed() -> Bool {
        return self.isDone() && self.opts.allowFragments
    }
    
    func ensureNotDone() throws {
        if self.isDone() {
            throw Error.UnexpectedEnd(self)
        }
    }
    
    mutating func nextAndCheckNotDone() throws {
        self.next()
        try self.ensureNotDone()
    }
    
    mutating func nextAndCheckNotDoneIfFragmentsDisallowed() throws {
        self.next()
        if self.opts.allowFragments { return }
        try self.ensureNotDone()
    }
    
    // Consumes all contiguous whitespace and returns # of consumed chars
    mutating func consumeWhitespace() -> Int {
        var counter = 0
        while !self.isDone() {
            let char = try! self.curr()
            if Const.Whitespace.contains(char) {
                //consume
                counter += 1
                self.next()
            } else {
                //non-whitespace, return
                break
            }
        }
        return counter
    }
    
    // Iterates both readers and checks that characters match until
    // a) expectedReader runs out of characters -> great! all match
    // b) self runs out of characters -> bad, no match!
    // c) we encounter a difference -> bad, no match!
    mutating func stopAtFirstDifference(o: Reader) throws {
        
        var other = o
        
        while true {
            
            if other.isDone() {
                //a) all matched, return
                return
            }
            
            if self.isDone() {
                //b) no match
                throw Error.Mismatch(self, other)
            }

            let charSelf = try! self.curr()
            let charOther = try! other.curr()
            guard charSelf == charOther else {
                //c) no match
                throw Error.Mismatch(self, other)
            }
            
            self.next()
            other.next()
        }
    }
}


