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
            let data = self.randomData(range: 0..<8, time: 0..<8, count: 3)
            let result0 = DirectTimeSolver().run(items: data.0, times: data.1)
            let result1 = TreeTimeSolver().run(items: data.0, times: data.1)
            
            let isEqual = result0 == result1
            if !isEqual {
                print("ranges: \(data.0.text)")
                print("times: \(data.1.text)")
                break
            }
            
            XCTAssertTrue(isEqual)
        }
    }
    
    func test_big_random() throws {
        for _ in 0...10000 {
            let data = self.randomData(range: 0..<100, time: 0..<100, count: 100)
            let result0 = DirectTimeSolver().run(items: data.0, times: data.1)
            let result1 = TreeTimeSolver().run(items: data.0, times: data.1)
            
            let isEqual = result0 == result1
            if !isEqual {
                print("ranges: \(data.0.text)")
                print("times: \(data.1.text)")
                break
            }
            
            XCTAssertTrue(isEqual)
        }
    }
    
    func test_0() throws {
        let items = [
            TimeIntervalValue(value: 2, start: 0, end: 4),
            TimeIntervalValue(value: 6, start: 0, end: 4),
            TimeIntervalValue(value: 1, start: 0, end: 5)
        ]
        let times = [
            TimeValue(value: 1, time: 2),
            TimeValue(value: 5, time: 2),
            TimeValue(value: 7, time: 4)
        ]
        
        let result0 = DirectTimeSolver().run(items: items, times: times)
        let result1 = TreeTimeSolver().run(items: items, times: times)

        XCTAssertTrue(result0 == result1)
    }
    
    func test_1() throws {
        let items = [
            TimeIntervalValue(value: 5, start: 1, end: 6),
            TimeIntervalValue(value: 9, start: 2, end: 7),
            TimeIntervalValue(value: 6, start: 3, end: 4),
            TimeIntervalValue(value: 0, start: 3, end: 8)
        ]
        let times = [
            TimeValue(value: 3, time: 3),
            TimeValue(value: 0, time: 6)
        ]
        
        let result0 = DirectTimeSolver().run(items: items, times: times)
        let result1 = TreeTimeSolver().run(items: items, times: times)

        XCTAssertTrue(result0 == result1)
    }
    
    func test_2() throws {
        let items = [
            TimeIntervalValue(value: 5, start: 0, end: 7),
            TimeIntervalValue(value: 7, start: 1, end: 6),
            TimeIntervalValue(value: 0, start: 3, end: 6),
            TimeIntervalValue(value: 3, start: 3, end: 5),
            TimeIntervalValue(value: 0, start: 4, end: 5)
        ]
        let times = [
            TimeValue(value: 7, time: 2),
            TimeValue(value: 6, time: 4),
            TimeValue(value: 6, time: 5),
            TimeValue(value: 0, time: 5),
            TimeValue(value: 3, time: 7),
            TimeValue(value: 7, time: 7)
        ]
        
        let result0 = DirectTimeSolver().run(items: items, times: times)
        let result1 = TreeTimeSolver().run(items: items, times: times)

        XCTAssertTrue(result0 == result1)
    }
    

    private func randomData(range: Range<Int>, time: Range<Int>, count: Int) -> ([TimeIntervalValue], [TimeValue]) {
        let rValues = TimeValueGenerator.randomTimeRanges(range: range, time: time, count: count)
        let tValues = TimeValueGenerator.randomTimeValues(range: range, time: time, count: count)
        
        var map = [Int : [TimeIntervalValue]]()
        
        for rValue in rValues {
            var array = map[rValue.value, default: []]
            array.append(rValue)
            map[rValue.value] = array
        }

        var ranges = [TimeIntervalValue]()
        for array in map.values {
            var t = -1
            for a in array {
                if a.start < t {
                    ranges.append(a)
                    t = a.end
                }
            }
        }
        
        let times = Array(Set(tValues)).sorted(by: { $0.time < $1.time })
        
        return (ranges, times)
    }
    
}


private extension Array where Element == TimeIntervalValue {
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
                result.append(",")
            }
            result.append("\n")
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
                result.append(",")
            }
            result.append("\n")
        }
        
        result.append("]")

        return result
    }
}

private extension TimeValue {
    var text: String {
        "TimeValue(value: \(self.value), time: \(self.time))"
    }
}

private extension TimeIntervalValue {
    var text: String {
        "RangeTimeValue(value: \(self.value), start: \(start), end: \(end))"
    }
}
