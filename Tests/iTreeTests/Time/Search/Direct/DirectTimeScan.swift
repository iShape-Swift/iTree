//
//  DirectTimeScan.swift
//
//
//  Created by Nail Sharipov on 29.02.2024.
//

struct DirectTimeScan {

    private var buffer: [TimeIntervalValue] = []

    mutating func insert(item: TimeIntervalValue) {
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
    
    mutating func findInRange(range: TimeRangeValue) -> [Int] {
        var i = 0
        var result = [Int]()
        while i < self.buffer.count {
            if self.buffer[i].end <= range.time {
                self.buffer.swapRemove(i)
            } else {
                let value = self.buffer[i].value
                if value >= range.min && value <= range.max {
                    result.append(value)
                }
                
                i += 1
            }
        }

        result.sort(by: { $0 < $1 })
        
        return result
    }
    
}
