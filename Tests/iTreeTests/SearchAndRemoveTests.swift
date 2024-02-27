//
//  SearchAndRemoveTests.swift
//  
//
//  Created by Nail Sharipov on 27.02.2024.
//

import XCTest
@testable import iTree

final class SearchAndRemoveTests: XCTestCase {
    
    func test_0() throws {
        var tree = RBTree(empty: TimeNode(time: 0, value: 0))
        let a = tree.find(value: 0, stop: 5)
        
        XCTAssertEqual(a, nil)
    }
    
    func test_1() throws {
        var tree = RBTree(empty: TimeNode(time: 0, value: 0))
        tree.insert(value: TimeNode(time: 3, value: 0))
        let a = tree.find(value: 0, stop: 2)
        let b = tree.find(value: 0, stop: 5)

        XCTAssertEqual(a, 0)
        XCTAssertEqual(b, nil)
    }
    
    func test_2() throws {
        var tree = RBTree(empty: TimeNode(time: 0, value: 0))
        tree.insert(value: TimeNode(time: 0, value: 10))
        tree.insert(value: TimeNode(time: 1, value: 5))
        tree.insert(value: TimeNode(time: 2, value: 15))

        tree.delete(value: TimeNode(time: 0, value: 10))
    }
    
    
}

extension RBTree where T == TimeNode {
    
    mutating func find(value: Int, stop: Int) -> Int? {
        var index = root
        while index != .empty {
            let node = self[index]
            if node.value.time <= stop {
                self.delete(index: index)
                if node.parent != .empty {
                    index = node.parent
                } else {
                    index = root
                }
            } else {
                if node.value.value == value {
                    return value
                } else if node.value.value > value {
                    index = node.right
                } else {
                    index = node.left
                }
            }
        }
        
        return nil
    }
    
}


struct TimeNode {
    let time: Int
    let value: Int
}

extension TimeNode: Comparable {

    static func < (lhs: TimeNode, rhs: TimeNode) -> Bool {
        lhs.value < rhs.value
    }
}

extension TimeNode: Equatable {

    public static func == (lhs: TimeNode, rhs: TimeNode) -> Bool {
        lhs.value == rhs.value
    }
}
