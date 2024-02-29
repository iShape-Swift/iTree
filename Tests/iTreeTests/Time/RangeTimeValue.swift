//
//  RangeTimeValue.swift
//  
//
//  Created by Nail Sharipov on 29.02.2024.
//

struct RangeTimeValue: Hashable {
    let value: Int
    let start: Int
    let end: Int
}

extension RangeTimeValue: Comparable {
    
    @inline(__always)
    public static func < (lhs: RangeTimeValue, rhs: RangeTimeValue) -> Bool {
        lhs.value < rhs.value
    }
    @inline(__always)
    public static func == (lhs: RangeTimeValue, rhs: RangeTimeValue) -> Bool {
        lhs.value == rhs.value
    }
}
