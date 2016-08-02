//
//  Friend.swift
//  ISSOverhead
//
//  Created by Andrew Sowers on 8/1/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation

struct Friend {
    let name: String
    let locaiton: ISSPosition
    init(name: String, locaiton: ISSPosition) {
        self.name = name
        self.locaiton = locaiton
    }
}

extension Friend: Equatable { }
func ==(lhs: Friend, rhs: Friend) -> Bool {
    return lhs.name == rhs.name && lhs.locaiton == rhs.locaiton ? true : false
}