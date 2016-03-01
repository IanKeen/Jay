//
//  NativeParser.swift
//  Jay
//
//  Created by Honza Dvorsky on 2/18/16.
//  Copyright © 2016 Honza Dvorsky. All rights reserved.
//

//converts the intermediate Jay types into Swift types

struct NativeParser {
    
    let opts: JayOpts
    init(_ opts: JayOpts) {
        self.opts = opts
    }

    func parse(data: [UInt8]) throws -> Any {
        
        let jsonValue = try Parser(self.opts).parseJsonFromData(data)
        
        //recursively convert into native types
        let native = jsonValue.toNative()
        return native
    }
}


