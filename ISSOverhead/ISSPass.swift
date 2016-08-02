//
//  ISSPass.swift
//  ISSOverhead
//
//  Created by Andrew Sowers on 8/1/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import Argo
import Runes
import Curry

struct ISSPasses {
    let passes: [ISSPass]
    init(passes: [ISSPass]) {
        self.passes = passes
    }
}

extension ISSPasses: Decodable {
    static func decode(json: JSON) -> Decoded<ISSPasses> {
        return curry(self.init)
            <^> json <|| "response"
    }
}

struct ISSPass {
    let duration: Int
    let riseTime: Int64
    init(duration: Int, riseTime: Int64) {
        self.duration = duration
        self.riseTime = riseTime
    }
}

extension ISSPass: Decodable {
    static func decode(json: JSON) -> Decoded<ISSPass> {
        return curry(self.init)
            <^> json <| "duration"
            <*> json <| "risetime"
    }
}


