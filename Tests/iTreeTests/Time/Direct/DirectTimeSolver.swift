//
//  DirectTimeSolver.swift
//  
//
//  Created by Nail Sharipov on 29.02.2024.
//

struct DirectTimeSolver {
    
    func run(items: [RangeTimeValue], times: [TimeValue]) -> [Int] {

        var scanList = DirectTimeScan()
        
        var result = [Int]()
        result.reserveCapacity(items.count)

        var i = 0
        for t in times {
            while i < items.count && items[i].start <= t.time {
                if items[i].end > t.time {
                    scanList.insert(item: items[i])
                }
                i += 1
            }

            result.append(scanList.findEqualOrLower(time: t))
        }
        
        return result
    }
    
}
