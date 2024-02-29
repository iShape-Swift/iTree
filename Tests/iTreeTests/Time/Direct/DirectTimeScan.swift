//
//  DirectTimeScan.swift
//
//
//  Created by Nail Sharipov on 29.02.2024.
//

struct DirectTimeScan {

    private var buffer: [RangeTimeValue] = []

    mutating func insert(item: RangeTimeValue) {
        buffer.append(item)
    }
    
    mutating func findEqualOrLower(time t: TimeValue) -> Int {
        var i = 0
        var result: Int = .min
        while i < self.buffer.count {
            if self.buffer[i].end <= t.time {
                self.buffer.swapRemove(i)
            } else {
                let value = self.buffer[i].value
                if value == t.value {
                    return value
                } else if value < t.value {
                    result = max(value, result)
                }
                
                i += 1
            }
        }
        
        return result
    }
}
