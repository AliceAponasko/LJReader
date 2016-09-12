//
//  NSDateExtension.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/27/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import Foundation

extension NSDate: Comparable {}

func < (lhs: NSDate?, rhs: NSDate?) -> Bool {
    if let date1 = lhs, date2 = rhs {
        return date1 < date2
    }
    return false
}

func <= (lhs: NSDate?, rhs: NSDate?) -> Bool {
    if let date1 = lhs, date2 = rhs {
        return date1 <= date2
    }
    return false
}

public func < (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

public func <= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs < rhs ||
        lhs.compare(rhs) == .OrderedSame
}

func > (lhs: NSDate?, rhs: NSDate?) -> Bool {
    if let date1 = lhs, date2 = rhs {
        return date1 > date2
    }
    return false
}

func >= (lhs: NSDate?, rhs: NSDate?) -> Bool {
    if let date1 = lhs, date2 = rhs {
        return date1 >= date2
    }
    return false
}

public func > (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedDescending
}

public func >= (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs > rhs ||
        lhs.compare(rhs) == .OrderedSame
}

extension NSDate {

    func between(startDate: NSDate, _ endDate: NSDate) -> Bool {
        return (startDate < self) && (self < endDate)
    }
}
