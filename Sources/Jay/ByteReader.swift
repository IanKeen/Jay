//
//  ByteReader.swift
//  Jay
//
//  Created by Honza Dvorsky on 2/17/16.
//  Copyright © 2016 Honza Dvorsky. All rights reserved.
//

struct ByteReader: Reader {
    
    private let content: [JChar]
    private var cursor: Array<JChar>.Index
    let opts: JayOpts
    
    init(content: [JChar], opts: JayOpts) {
        self.content = content
        self.cursor = self.content.startIndex
        self.opts = opts
    }
    
    mutating func next() {
        precondition(!self.isDone())
        self.cursor = self.cursor.successor()
    }
    
    func peek(next: Int) -> [JChar] {
        
        let take = min(next, self.content.endIndex - self.cursor)
        let range = self.cursor..<self.cursor.advancedBy(take)
        return Array(self.content[range])
    }
    
    func curr() throws -> JChar {
        guard !self.isDone() else { throw Error.UnexpectedEnd(self) }
        return self.content[self.cursor]
    }
    
    func isDone() -> Bool {
        return self.cursor == self.content.endIndex
    }
    
    init(content: String, opts: JayOpts = JayOpts()) {
        self.init(content: content.chars(), opts: opts)
    }
}
