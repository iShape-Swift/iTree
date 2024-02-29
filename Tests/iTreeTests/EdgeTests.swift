//
//  EdgeTests.swift
//
//
//  Created by Nail Sharipov on 28.02.2024.
//

import XCTest
@testable import iTree
import iFixFloat

final class EdgeTests: XCTestCase {
    
    func test_single_random() throws {
        let edges = self.randomEdges(range: 0..<10, length: 2..<6, count: 20)
        let points = self.randomPoints(range: 0..<10, count: 20, exclude: edges)
        let result0 = PointDirectSolver().run(items: edges, points: points)
        let result1 = PointTreeSolver().run(items: edges, points: points)
        
        let isEqual = result0 == result1
        if !isEqual {
            print("edges: \(edges.text)")
            print("points: \(points.text)")
        }

        XCTAssertTrue(isEqual)
    }
    
    func test_random_small() throws {
        for _ in 0...100000 {
            let edges = self.randomEdges(range: 0..<8, length: 2..<6, count: 8)
            let points = self.randomPoints(range: 0..<8, count: 5, exclude: edges)
            let result0 = PointDirectSolver().run(items: edges, points: points)
            let result1 = PointTreeSolver().run(items: edges, points: points)
            
            let isEqual = result0 == result1
            if !isEqual {
                print("edges: \(edges.text)")
                print("points: \(points.text)")
                XCTAssertTrue(isEqual)
                break
            }
            
            XCTAssertTrue(isEqual)
        }
    }
    
    func test_0() throws {
        let edges = [
            IdSegment(index: 1, segment: Segment(a: Point(x: 3, y: 3), b: Point(x: 4, y: 2))),
            IdSegment(index: 0, segment: Segment(a: Point(x: 4, y: 1), b: Point(x: 6, y: 7))),
            IdSegment(index: 2, segment: Segment(a: Point(x: 5, y: 1), b: Point(x: 6, y: 0)))
        ]
        
        let points = [Point(x: 3, y: 7), Point(x: 5, y: 7)]
        
        let result0 = PointDirectSolver().run(items: edges, points: points)
        let result1 = PointTreeSolver().run(items: edges, points: points)

        XCTAssertEqual(result0, result1)
    }
    
    func test_1() throws {
        let edges = [
            IdSegment(index: 0, segment: Segment(a: Point(x: 1, y: 5), b: Point(x: 1, y: 6))),
            IdSegment(index: 1, segment: Segment(a: Point(x: 1, y: 5), b: Point(x: 6, y: 0))),
            IdSegment(index: 3, segment: Segment(a: Point(x: 1, y: 3), b: Point(x: 2, y: 2))),
            IdSegment(index: 2, segment: Segment(a: Point(x: 4, y: 4), b: Point(x: 5, y: 5)))
        ]
        
        let points = [Point(x: 1, y: 7)]
        
        let result0 = PointDirectSolver().run(items: edges, points: points)
        let result1 = PointTreeSolver().run(items: edges, points: points)

        XCTAssertTrue(result0 == result1)
    }
    
    
    
    
    private func randomEdges(range: Range<Int32>, length: Range<Int32>, count: Int) -> [IdSegment] {
        let list = CrossSolver.randomSegments(range: range, length: length, count: count)
        var result = [IdSegment]()
        result.reserveCapacity(list.count)
        
        for i in 0..<list.count {
            let e = list[i]
            let segment = e.a.x <= e.b.x ? Segment(a: e.a, b: e.b) : Segment(a: e.b, b: e.a)
            result.append(IdSegment(index: i, segment: segment))
        }
        
        result.sort(by: { $0.segment.a.x < $1.segment.a.x })
        
        return result
    }
    
    private func randomPoints(range: Range<Int32>, count: Int, exclude: [IdSegment]) -> [Point] {
        var pSet = Set<Point>()
        pSet.reserveCapacity(exclude.count)
        for e in exclude {
            pSet.insert(e.segment.a)
            pSet.insert(e.segment.b)
        }
        
        
        var result = [Point]()
        result.reserveCapacity(count)
        
        for _ in 0..<count {
            var p = Point(Int32.random(in: range), Int32.random(in: range))
            while pSet.contains(p) {
                p = Point(Int32.random(in: range), Int32.random(in: range))
            }
            result.append(p)
        }
        
        result.sort(by: { $0.x < $1.x })
        
        return result
    }
}

private extension Array where Element == Point {
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

private extension Array where Element == IdSegment {
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

private extension Point {
    var text: String {
        "Point(x: \(self.x), y: \(self.y))"
    }
}

private extension IdSegment {
    var text: String {
        "IdSegment(index: \(self.index), segment: Segment(a: \(self.segment.a.text), b: \(self.segment.b.text)))"
    }
}
