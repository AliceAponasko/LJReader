//
//  NSDateExtension.swift
//  LJReader
//
//  Created by Alice Aponasko on 2/27/16.
//  Copyright © 2016 aliceaponasko. All rights reserved.
//

import Foundation

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }