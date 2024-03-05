//
//  TimeIntervalValue.swift
//  
//
//  Created by Nail Sharipov on 29.02.2024.
//

struct TimeIntervalValue: Hashable {
    let value: Int
    let start: Int
    let end: Int
}

extension TimeIntervalValue: Comparable {
    
    @inline(__always)
    public static func < (lhs: TimeIntervalValue, rhs: TimeIntervalValue) -> Bool {
        lhs.value < rhs.value
    }
    @inline(__always)
    public static func == (lhs: TimeIntervalValue, rhs: TimeIntervalValue) -> Bool {
        lhs.value == rhs.value
    }
}
