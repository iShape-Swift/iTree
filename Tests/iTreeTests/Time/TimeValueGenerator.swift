//
//  TimeValueGenerator.swift
//
//
//  Created by Nail Sharipov on 29.02.2024.
//

struct TimeValueGenerator {
    
    static func randomTimeRanges(range: Range<Int>, time: Range<Int>, count: Int) -> [RangeTimeValue] {
        var result = [RangeTimeValue]()
        result.reserveCapacity(count)
        
        for _ in 0..<count {
            let value = Int.random(in: range)
            let t0 = Int.random(in: time)
            let t1 = Int.random(in: time)
            
            let start: Int
            let end: Int
            if t0 == t1 {
                start = t0
                end = t0 + 1
            } else if t0 < t1 {
                start = t0
                end = t1
            } else {
                start = t1
                end = t0
            }
            
            result.append(RangeTimeValue(value: value, start: start, end: end))
        }
        
        return result
    }
    
    static func randomTimeValues(range: Range<Int>, time: Range<Int>, count: Int) -> [TimeValue] {
        var result = [TimeValue]()
        result.reserveCapacity(count)
        
        for _ in 0..<count {
            let value = Int.random(in: range)
            let t = Int.random(in: time)
            result.append(TimeValue(value: value, time: t))
        }
        
        return result
    }
    
}
