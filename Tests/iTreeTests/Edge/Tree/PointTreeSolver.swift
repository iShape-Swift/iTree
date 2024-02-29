//
//  PointTreeSolver.swift
//
//
//  Created by Nail Sharipov on 28.02.2024.
//

import iFixFloat

struct PointTreeSolver {
    
    func run(items: [IdSegment], points: [Point]) -> [Int] {

        var scanList = TreeScan()
        
        var result = [Int]()
        result.reserveCapacity(items.count)

        var i = 0
        for p in points {
            
            while i < items.count && items[i].segment.a.x <= p.x {
                if !items[i].segment.isVertical && items[i].segment.b.x > p.x {
                    scanList.insert(item: items[i], stop: p.x)
                }
                i += 1
            }
            
            let index = scanList.findUnder(point: p, stop: p.x)?.index ?? .max
            result.append(index)
        }
        
        return result
    }
    
}
