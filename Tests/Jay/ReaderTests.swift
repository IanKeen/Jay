//
//  ReaderTests.swift
//  Jay
//
//  Created by Honza Dvorsky on 2/17/16.
//  Copyright © 2016 Honza Dvorsky. All rights reserved.
//

import XCTest
@testable import Jay

class ReaderTests: XCTestCase {

    func testConsumingWhitespace_Normal() {
        
        var reader = ByteReader(content: " \n  \t \r  lala ")
        let consumed = reader.consumeWhitespace()
        XCTAssertEqual(consumed, 9)
        XCTAssert(reader.curr() == "l".char())
    }
    
    func testConsumingWhitespace_NoWhitespace() {
        
        var reader = ByteReader(content: "lala ")
        let consumed = reader.consumeWhitespace()
        XCTAssertEqual(consumed, 0)
        XCTAssert(reader.curr() == "l".char())
    }
    
    func testConsumingWhitespace_Empty() {
        
        var reader = ByteReader(content: "")
        let consumed = reader.consumeWhitespace()
        XCTAssertEqual(consumed, 0)
        XCTAssertTrue(reader.isDone())
    }
    
    func testStopAtFirstDifference_RegularMismatch() {
        
        //regular mismatch case
        var mainReader = ByteReader(content: "hello")
        let expectedReader = ByteReader(content: "hearing")
        do {
            try mainReader.stopAtFirstDifference(expectedReader)
            XCTFail()
        } catch Error.Mismatch(let main, let other) {
            
            XCTAssert(!main.isDone())
            XCTAssert(!other.isDone())
            XCTAssert(main.curr() == "l".char())
            XCTAssert(other.curr() == "a".char())
        } catch {
            XCTFail()
        }
    }

    func testStopAtFirstDifference_EmptyMain() {
        
        //regular mismatch case
        var mainReader = ByteReader(content: "")
        let expectedReader = ByteReader(content: "hearing")
        do {
            try mainReader.stopAtFirstDifference(expectedReader)
            XCTFail()
        } catch Error.Mismatch(let main, let other) {
            XCTAssert(main.isDone())
            XCTAssert(!other.isDone())
            XCTAssert(other.curr() == "h".char())
        } catch {
            XCTFail()
        }
    }

    func testStopAtFirstDifference_EmptyExpected() {
        
        //regular mismatch case
        var mainReader = ByteReader(content: "hello")
        let expectedReader = ByteReader(content: "")
        do {
            try mainReader.stopAtFirstDifference(expectedReader)
        } catch {
            XCTFail()
        }
    }
    
    func testStopAtFirstDifference_Normal() {
        
        //regular mismatch case
        var mainReader = ByteReader(content: "hello world")
        let expectedReader = ByteReader(content: "hello w")
        do {
            try mainReader.stopAtFirstDifference(expectedReader)
            XCTAssert(!mainReader.isDone())
            XCTAssert(mainReader.curr() == "o".char())
        } catch {
            XCTFail()
        }
    }
    
    func testPeek_EnoughAvailable() {
        var mainReader = ByteReader(content: "hello world")
        mainReader.next()
        mainReader.next()
        XCTAssert(mainReader.peek(5) == "llo w".chars())
    }
    
    func testPeek_LessAvailable() {
        var mainReader = ByteReader(content: "hello world")
        mainReader.next()
        mainReader.next()
        XCTAssert(mainReader.peek(12) == "llo world".chars())
    }
    
    func testPeek_NoAvailable() {
        var mainReader = ByteReader(content: "hey")
        mainReader.next()
        mainReader.next()
        mainReader.next()
        XCTAssert(mainReader.peek(5) == [])
    }

    func testReadNext_EnoughAvailable() {
        var mainReader = ByteReader(content: "hello world")
        try! mainReader.readNext(2)
        let next = try! mainReader.readNext(5)
        XCTAssert(next == "llo w".chars())
        XCTAssert(mainReader.curr() == "o".char())
    }
    
    func testReadNext_LessAvailable() {
        var mainReader = ByteReader(content: "hello world")
        XCTAssertNil(try? mainReader.readNext(12))
    }

}
