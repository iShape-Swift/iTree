//
//  DirectScan.swift
//
//
//  Created by Nail Sharipov on 28.02.2024.
//

import iFixFloat

struct DirectScan {
    
    private var buffer: [IdSegment] = []

    mutating func insert(item: IdSegment) {
        buffer.append(item)
    }
    
    mutating func findUnder(point p: Point, stop: Int32) -> IdSegment? {
        var i = 0
        var result: IdSegment? = nil
        while i < self.buffer.count {
            if self.buffer[i].segment.b.x <= stop {
                self.buffer.swapRemove(i)
            } else {
                let segment = self.buffer[i].segment
                if segment.isUnder(point: p) {
                    if let bestSeg = result?.segment {
                        if bestSeg.isUnder(segment: segment) {
                            result = self.buffer[i]
                        }
                    } else {
                        result = self.buffer[i]
                    }
                }
                
                i += 1
            }
        }
        
        return result
    }
}

extension Array {

    mutating func swapRemove(_ index: Int) {
        if index < self.count - 1 {
            self[index] = self.removeLast()
        } else {
            self.removeLast()
        }
    }
}
