//
//  ArrayTests.swift
//
//
//  Created by Nail Sharipov on 27.04.2024.
//

import XCTest
@testable import iTree

final class ArrayTests: XCTestCase {
    
    func test_orderedList_0() throws {
        var list = [6, 3, 4, 8, 1]
        var tree = RBTree(empty: 0, capacity: list.count)
        for a in list {
            tree.insert(value: a)
        }
        
        let ordered = tree.orderedList()
        list.sort()
        
        XCTAssertEqual(ordered, list)
    }
    
    func test_orderedList_random() throws {
        let n = 100
        var list = Array(0..<n)
        let sorted = list
        var tree = RBTree(empty: 0, capacity: list.count)
        for _ in 0..<10000 {
            list.shuffle()
            tree.clearAll()
            for a in list {
                tree.insert(value: a)
            }
            
            let ordered = tree.orderedList()
            
            XCTAssertEqual(ordered, sorted)
        }
    }
    
    func test_init_0() throws {
        let list = [0]
        let tree = RBTree(empty: 0, array: list[...])
        let ordered = tree.orderedList()
        XCTAssertEqual(ordered, list)
    }
    
    func test_init_1() throws {
        let list = [0, 1]
        let tree = RBTree(empty: 0, array: list[...])
        let ordered = tree.orderedList()
        XCTAssertEqual(ordered, list)
    }
    
    func test_init_2() throws {
        let list = Array(0...2)
        let tree = RBTree(empty: 0, array: list[...])
        let ordered = tree.orderedList()
        XCTAssertEqual(ordered, list)
    }
    
    func test_init_3() throws {
        let list = Array(0...3)
        let tree = RBTree(empty: 0, array: list[...])
        let ordered = tree.orderedList()
        XCTAssertEqual(ordered, list)
    }
    
    func test_init_4() throws {
        let list = Array(0...4)
        let tree = RBTree(empty: 0, array: list[...])
        let ordered = tree.orderedList()
        XCTAssertEqual(ordered, list)
    }
    
    func test_init_5() throws {
        let list = Array(0...5)
        let tree = RBTree(empty: 0, array: list[...])
        let ordered = tree.orderedList()
        XCTAssertEqual(ordered, list)
    }
    
    func test_init_6() throws {
        let list = Array(0...6)
        let tree = RBTree(empty: 0, array: list[...])
        let ordered = tree.orderedList()
        XCTAssertEqual(ordered, list)
    }
    
    func test_init_7() throws {
        let list = Array(0...7)
        let tree = RBTree(empty: 0, array: list[...])
        let ordered = tree.orderedList()
        XCTAssertEqual(ordered, list)
    }
    
    func test_init_31() throws {
        let list = Array(0...31)
        let tree = RBTree(empty: 0, array: list[...])
        let ordered = tree.orderedList()
        XCTAssertEqual(ordered, list)
    }
    
    func test_init_48() throws {
        let list = Array(0...48)
        let tree = RBTree(empty: 0, array: list[...])
        let ordered = tree.orderedList()
        XCTAssertEqual(ordered, list)
    }
    
    func test_init_sequence() throws {
        for i in 8...2050 {
            let list = Array(0..<i)
            let tree = RBTree(empty: 0, array: list[...])
            let ordered = tree.orderedList()
            XCTAssertEqual(ordered, list)
        }
    }
    
    func test_next_by_order_0() throws {
        self.test_next_by_order(list: [0])
    }

    func test_next_by_order_1() throws {
        self.test_next_by_order(list: [0, 1])
    }
    
    func test_next_by_order_2() throws {
        self.test_next_by_order(list: Array(0...2))
    }

    func test_next_by_order_3() throws {
        self.test_next_by_order(list: Array(0...3))
    }
    
    func test_next_by_order_4() throws {
        self.test_next_by_order(list: Array(0...4))
    }
    
    func test_next_by_order_sequence() throws {
        for i in 8...550 {
            self.test_next_by_order(list: Array(0..<i))
        }
    }
    
    private func test_next_by_order(list: [Int]) {
        let tree = RBTree(empty: 0, array: list[...])
        var nIndex = tree.firstByOrder()
        
        var ordered = [Int]()
        while nIndex != .empty {
            ordered.append(tree[nIndex].value)
            nIndex = tree.nextByOrder(index: nIndex)
        }
        
        XCTAssertEqual(ordered, list)
    }
    
}
