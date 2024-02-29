//
//  TimeTests.swift
//
//
//  Created by Nail Sharipov on 29.02.2024.
//

import XCTest
@testable import iTree

final class TimeTests: XCTestCase {
    
    func test_single_random() throws {
        let data = self.randomData(range: 0..<8, time: 0..<8, count: 10)
        let result0 = DirectTimeSolver().run(items: data.0, times: data.1)
        let result1 = TreeTimeSolver().run(items: data.0, times: data.1)
        
        let isEqual = result0 == result1
        if !isEqual {
            print("ranges: \(data.0.text)")
            print("times: \(data.1.text)")
        }

        XCTAssertTrue(isEqual)
    }
    
    func test_small_random() throws {
        for _ in 0...100000 {
            let data = self.randomData(range: 0..<8, time: 0..<8, count: 10)
            let result0 = DirectTimeSolver().run(items: data.0, times: data.1)
            let result1 = TreeTimeSolver().run(items: data.0, times: data.1)
            
            let isEqual = result0 == result1
            if !isEqual {
                print("ranges: \(data.0.text)")
                print("times: \(data.1.text)")
            }
            
            XCTAssertTrue(isEqual)
        }
    }
    
    func test_big_random() throws {
        for _ in 0...1000 {
            let data = self.randomData(range: 0..<100, time: 0..<100, count: 1000)
            let result0 = DirectTimeSolver().run(items: data.0, times: data.1)
            let result1 = TreeTimeSolver().run(items: data.0, times: data.1)
            
            let isEqual = result0 == result1
            if !isEqual {
                print("ranges: \(data.0.text)")
                print("times: \(data.1.text)")
            }
            
            XCTAssertTrue(isEqual)
        }
    }

    private func randomData(range: Range<Int>, time: Range<Int>, count: Int) -> ([RangeTimeValue], [TimeValue]) {
        let rValues = TimeValueGenerator.randomTimeRanges(range: range, time: time, count: count)
        let tValues = TimeValueGenerator.randomTimeValues(range: range, time: time, count: count)
        
        let ranges = Array(Set(rValues)).sorted(by: { $0.start < $1.start })
        let times = Array(Set(tValues)).sorted(by: { $0.time < $1.time })
        
        return (ranges, times)
    }
    
}


private extension Array where Element == RangeTimeValue {
    var text: String {
        guard !self.isEmpty else {
            return ""
        }
        
        var result = String()
        result.append("[")
        
        let last = self.count - 1
        for i in 0...last {
            let p = self[i]
            result.append(p.text)
            if i != last {
                result.append(", ")
            }
        }
        
        result.append("]")

        return result
    }
}

private extension Array where Element == TimeValue {
    var text: String {
        guard !self.isEmpty else {
            return ""
        }
        
        var result = String()
        result.append("[")
        
        let last = self.count - 1
        for i in 0...last {
            let s = self[i]
            result.append(s.text)
            if i != last {
                result.append(",\n")
            }
        }
        
        result.append("]")

        return result
    }
}

private extension TimeValue {
    var text: String {
        "TimeValue(time: \(self.time), value: \(self.value))"
    }
}

private extension RangeTimeValue {
    var text: String {
        "RangeTimeValue(value: \(self.value), start: \(start), end: \(end))"
    }
}
