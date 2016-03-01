//
//  RootParser.swift
//  Jay
//
//  Created by Honza Dvorsky on 2/17/16.
//  Copyright © 2016 Honza Dvorsky. All rights reserved.
//

struct RootParser: JsonParser {
    
    let opts: JayOpts
    init(_ opts: JayOpts) {
        self.opts = opts
    }

    func parse(withReader r: Reader) throws -> (JsonValue, Reader) {
        
        var reader = try self.prepareForReading(withReader: r)

        //only allow fragments if the option was explicitly requested
        if self.opts.allowFragments {
            //in that case use the (any) value parser
            return try ValueParser().parse(withReader: reader)
        }
        
        //otherwise only allow object or array as top object
        let root: JsonValue
        switch try reader.curr() {
        case Const.BeginObject:
            (root, reader) = try ObjectParser().parse(withReader: reader)
        case Const.BeginArray:
            (root, reader) = try ArrayParser().parse(withReader: reader)
        default:
            throw Error.Unimplemented("ParseRoot")
        }
        return (root, reader)
    }
}
