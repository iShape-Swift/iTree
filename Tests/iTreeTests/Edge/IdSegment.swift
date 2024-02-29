//
//  IdSegment.swift
//
//
//  Created by Nail Sharipov on 28.02.2024.
//

import iFixFloat

struct Segment {
    let a: Point
    let b: Point
    
    var isVertical: Bool {
        a.x == b.x
    }
    
    init(a: Point, b: Point) {
        assert(a.x <= b.x)
        self.a = a
        self.b = b
    }
}

struct IdSegment {
    let index: Int
    let segment: Segment
}


extension Segment {
    
    /// Determines if a point `p` is under a segment
    /// - Note: This function assumes `a.x <= p.x < b.x`, and `p != a` and `p != b`.
    /// - Parameters:
    ///   - p: The point to check.
    /// - Returns: `true` if point `p` is under the segment, `false` otherwise.
    @inline(__always) func isUnder(point p: Point) -> Bool {
        assert(a.x <= p.x && p.x <= b.x)
        assert(p != a && p != b)
        return Triangle.isClockwisePoints(p0: a, p1: p, p2: b)
    }

    /// Determines if a point `p` is above a segment
    /// - Note: This function assumes `a.x <= p.x < b.x`.
    /// - Parameters:
    ///   - p: The point to check.
    /// - Returns: `true` if point `p` is above the segment, `false` otherwise.
    @inline(__always) func isAbove(point p: Point) -> Bool {
        assert(a.x <= p.x && p.x <= b.x)
        return Triangle.isClockwisePoints(p0: a, p1: b, p2: p)
    }
    
    /// Determines if first segment is under the second segment
    /// - Note: This function assumes `other.a.x < b.x`, `a.x < other.b.x`.
    /// - Parameters:
    ///   - other: second segment
    /// - Returns: `true` if point first segment is under the second segment, `false` otherwise.
    @inline(__always) func isUnder(segment other: Segment) -> Bool {
        if a == other.a {
            return Triangle.isClockwisePoints(p0: a, p1: other.b, p2: b)
        } else if a.x < other.a.x {
            return Triangle.isClockwisePoints(p0: a, p1: other.a, p2: b)
        } else {
            return Triangle.isClockwisePoints(p0: other.a, p1: other.b, p2: a)
        }
    }
    
    @inline(__always) func isLess(_ other: Segment) -> Bool {
        let a0 = self.a.bitPack
        let a1 = other.a.bitPack
        if a0 != a1 {
            return a0 < a1
        } else {
            return self.b.bitPack < other.b.bitPack
        }
    }
}


private extension Triangle {
    
    @inline(__always)
    static func isClockwisePoints(p0: Point, p1: Point, p2: Point) -> Bool {
        Triangle.isClockwise(p0: FixVec(p0), p1: FixVec(p1), p2: FixVec(p2))
    }
    
}


extension Segment: Comparable {
    
    @inline(__always)
    public static func < (lhs: Segment, rhs: Segment) -> Bool {
        lhs.isUnder(segment: rhs)
    }
    @inline(__always)
    public static func == (lhs: Segment, rhs: Segment) -> Bool {
        lhs.a == rhs.a && lhs.b == rhs.b
    }
}

extension IdSegment: Comparable {
    
    @inline(__always)
    public static func < (lhs: IdSegment, rhs: IdSegment) -> Bool {
        lhs.segment.isUnder(segment: rhs.segment)
    }
    @inline(__always)
    public static func == (lhs: IdSegment, rhs: IdSegment) -> Bool {
        lhs.segment == rhs.segment
    }
}
