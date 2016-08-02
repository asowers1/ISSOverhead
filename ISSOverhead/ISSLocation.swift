//
//  ISSLocation.swift
//  ISSOverhead
//
//  Created by Andrew Sowers on 8/1/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import Argo
import Runes
import Curry

struct ISSNow {
    let position: ISSPosition
    let timestamp: Int
    init(position: ISSPosition, timestamp: Int) {
        self.position = position
        self.timestamp = timestamp
    }
}

extension ISSNow: Decodable {
    static func decode(json: JSON) -> Decoded<ISSNow> {
        return curry(self.init)
            <^> json <| "iss_position"
            <*> json <| "timestamp"
    }
}

extension ISSNow: Equatable { }
func ==(lhs: ISSNow, rhs: ISSNow) -> Bool {
    return lhs.position == rhs.position && lhs.timestamp == rhs.timestamp ? true : false
}

struct ISSPosition {
    let lat: Double
    let lon: Double
    init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

extension ISSPosition: Decodable {
    static func decode(json: JSON) -> Decoded<ISSPosition> {
        return curry(self.init)
            <^> json <| "latitude"
            <*> json <| "longitude"
    }
}

extension ISSPosition: Equatable { }
func ==(lhs: ISSPosition, rhs: ISSPosition) -> Bool {
    return lhs.lat == rhs.lat && lhs.lon == rhs.lon ? true : false
}

typealias Position = ISSPosition
