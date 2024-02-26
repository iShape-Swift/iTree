import XCTest
@testable import iTree

final class iTreeTests: XCTestCase {
    
    func test_0() throws {
        let tree = RBTree(empty: 0)
        let a = tree.find(value: 1) ?? .max
        
        XCTAssertEqual(a, .max)
    }

    func test_1() throws {
        var tree = RBTree(empty: 0)
        tree.insert(value: 5)
        let a0 = tree.find(value: 1) ?? .max
        let a1 = tree.find(value: 5) ?? .max
        let a2 = tree.find(value: 7) ?? .max
        
        XCTAssertEqual(a0, .max)
        XCTAssertEqual(a1, 5)
        XCTAssertEqual(a2, .max)
    }

    func test_2() throws {
        var tree = RBTree(empty: 0)
        tree.insert(value: 5)
        tree.insert(value: 3)
        tree.insert(value: 1)
        let a0 = tree.find(value: 5) ?? .max
        let a1 = tree.find(value: 3) ?? .max
        let a2 = tree.find(value: 1) ?? .max
        
        XCTAssertEqual(a0, 5)
        XCTAssertEqual(a1, 3)
        XCTAssertEqual(a2, 1)
    }
    
    func test_3() throws {
        var tree = RBTree(empty: 0)

        tree.insert(value: 10)
        tree.insert(value: 15)
        tree.insert(value: 5)
        tree.insert(value: 4)
        
        XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated.")
    }
    
    func test_4() throws {
        var tree = RBTree(empty: 0)
        
        tree.insert(value: 10)
        tree.insert(value: 15)
        tree.insert(value: 5)
        tree.insert(value: 4)
        tree.insert(value: 6)
        
        _ = tree.verifyHeight(tree.root)
    }
    
    func test_5() throws {
        var tree = RBTree(empty: 0)

        tree.insert(value: 10)
        tree.insert(value: 20)
        tree.insert(value: 30)
        
        let rootValue = tree[tree.root].value
        
        XCTAssertTrue(rootValue == 20 || rootValue == 10, "Rotation not performed correctly.")
        XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
    }
    
    func test_6() throws {
        var tree = RBTree(empty: 0)

        tree.insert(value: 10)
        tree.insert(value: 15)
        tree.insert(value: 5)
        tree.insert(value: 4)
        tree.insert(value: 6)
        tree.insert(value: 20)
        
        tree.delete(value: 15) // Remove a node with children
        XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
        XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
    }
    
    func test_8() throws {
        var tree = RBTree(empty: 0)
        // Insert values in a specific order that requires rotations to maintain red-black properties
        tree.insert(value: 40)
        tree.insert(value: 20)
        tree.insert(value: 60)
        tree.insert(value: 10)
        tree.insert(value: 30)
        tree.insert(value: 50)
        tree.insert(value: 70)
        // After these insertions, the tree should have specific structure if rotations and recolorings are correct
        
        // Verify root and its children
        XCTAssertEqual(tree.value(tree.root), 40, "Root data is incorrect.")
        XCTAssertEqual(tree.leftValue(tree.root), 20, "Left child of root is incorrect.")
        XCTAssertEqual(tree.rightValue(tree.root), 60, "Right child of root is incorrect.")
    }
    
    func test_9() throws {
        
        for _ in 0...1000 {
            var tree = RBTree(empty: 0)
            let values = (1...100).shuffled() // Randomly ordered values
            for value in values {
                tree.insert(value: value)
            }
            
            // Delete a subset of values randomly
            for value in values.prefix(20).shuffled() {
                tree.delete(value: value)
            }
            
            // Verify the red-black properties
            XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
            XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
        }
    }

    func test_9b() throws {
        
        for _ in 0...1000 {
            var tree = RBTree(empty: 0)
            let values = (1...100).shuffled() // Randomly ordered values
            for value in values {
                tree.insert(value: value)
            }
            
            // Delete a subset of values randomly
            for value in values {
                tree.delete(value: value)
            }
            
            // Verify the red-black properties
            XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
            XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
        }
    }
    
    func test_9c() throws {
        
        for _ in 0...1000 {
            var tree = RBTree(empty: 0)
            let values = (1...100).shuffled() // Randomly ordered values
            var j = 0
            while j < values.count - 2 {
                tree.insert(value: values[j])
                tree.insert(value: values[j + 1])
                tree.insert(value: values[j + 2])
                tree.delete(value: values[j])
                tree.insert(value: values[j])
                j += 3
            }
            
            // Verify the red-black properties
            XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
            XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
        }
    }
    
    func test_10() throws {
        var tree = RBTree(empty: 0)
        let values = (1...100).shuffled() // Randomly ordered values
        for value in values {
            tree.insert(value: value)
        }
        
        for value in values {
            let foundValue = tree.find(value: value) ?? .max
            XCTAssertEqual(foundValue, value, "Value \(value) not found after random insertions.")
        }
    }
    
    func test_11() throws {
        var tree = RBTree(empty: 0)
        // Insert a sequence of values
        (1...100).forEach { tree.insert(value: $0) }
        
        let depth = tree.maxDepth(tree.root)
        // The maximum depth should not exceed 2*log2(n+1) for a perfectly balanced tree
        let expectedMaxDepth = Int(2 * log2(Double(100 + 1)))
        XCTAssertLessThanOrEqual(depth, expectedMaxDepth, "Tree is deeper than expected, indicating potential imbalance.")
    }

    func test_12() throws {
        var tree = RBTree(empty: 0)
        let values = (1...6).shuffled()
        print(values)
        for value in values {
            tree.insert(value: value)
        }
        
        // Delete a subset of values randomly
        for i in 0...1 {
            tree.delete(value: values[i])
        }
        
        // Verify the red-black properties
        XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
        XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
    }
    
    func test_12b() throws {
        var tree = RBTree(empty: 0)
        let values = (1...7).shuffled()
        print(values)
        var j = 0
        while j < values.count - 2 {
            tree.insert(value: values[j])
            tree.insert(value: values[j + 1])
            tree.insert(value: values[j + 2])
            tree.delete(value: values[j])
            j += 3
        }
        
        // Verify the red-black properties
        XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
        XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
    }
    
    func test_14() throws {
        var tree = RBTree(empty: 0)
        let values = [1, 6, 2, 5, 4]
        for value in values {
            tree.insert(value: value)
            XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
            XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
        }
        for i in 0...1 {
            tree.delete(value: values[i])
            XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
            XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
        }
    }
    
    func test_15() throws {
        var tree = RBTree(empty: 0)
        let values = [5, 6, 1, 3, 4, 2]
        for value in values {
            tree.insert(value: value)
            XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
            XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
        }
        for i in 0...1 {
            tree.delete(value: values[i])
            XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
            XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
        }
    }
    
    func test_17() throws {
        var tree = RBTree(empty: 0)
        // [6, 7, 2, 1, 4, 3, 5]
        tree.insert(value: 6)
        tree.insert(value: 7)
        tree.insert(value: 2)
        tree.delete(value: 6)

        tree.insert(value: 1)
        tree.insert(value: 4)
        tree.insert(value: 3)
        tree.delete(value: 1)
        
        tree.insert(value: 5)
        
        XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
        XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
    }
    
    func test_18() throws {
        var tree = RBTree(empty: 0)
        
        tree.insert(value: 10)
        tree.insert(value: 20)
        
        tree.delete(value: 10)
        tree.insert(value: 0)
        tree.insert(value: 3)
        tree.insert(value: 6)
        
        tree.delete(value: 3)
        tree.insert(value: 2)

        tree.delete(value: 2)
        tree.insert(value: 4)
        
        tree.delete(value: 6)
        tree.delete(value: 0)
        tree.delete(value: 4)
        
        tree.insert(value: 8)
        
        tree.delete(value: 20)
        tree.delete(value: 8)
        
        XCTAssertTrue(tree.verifyRedProperty(tree.root), "Red node property violated after rotations.")
        XCTAssertTrue(tree.verifyBlackHeightConsistency(tree.root), "Black height inconsistent after deletion.")
    }
    
}


private extension RBTree<Int> {

    func value(_ nIndex: UInt32) -> Int {
        guard nIndex != .empty else { return .max }
        return self[nIndex].value
    }
    
    func leftValue(_ nIndex: UInt32) -> Int {
        guard nIndex != .empty else { return .max }
        let node = self[nIndex]
        guard node.left != .empty else { return .max }
        return self[node.left].value
    }
    
    func rightValue(_ nIndex: UInt32) -> Int {
        guard nIndex != .empty else { return .max }
        let node = self[nIndex]
        guard node.right != .empty else { return .max }
        return self[node.right].value
    }
    
    func verifyRedProperty(_ nIndex: UInt32) -> Bool {
        guard nIndex != .empty else { return true }
        
        let node = self[nIndex]
        
        if self[nIndex].color == .red {
            let isLeftBlack = node.left == .empty || self[node.left].color == .black
            let isRightBlack = node.right == .empty || self[node.right].color == .black

            if !(isLeftBlack && isRightBlack) {
                return false
            }
        }

        return self.verifyRedProperty(node.left) && self.verifyRedProperty(node.right)
    }
    
    func verifyHeight(_ nIndex: UInt32) -> Int {
        guard nIndex != .empty else { return 1 }
        
        let node = self[nIndex]
        
        let leftHeight = self.verifyHeight(node.left)
        let rightHeight = self.verifyHeight(node.right)
        XCTAssertEqual(leftHeight, rightHeight, "Black height inconsistent.")
        return (node.color == .black ? 1 : 0) + leftHeight
    }
    
    func verifyBlackHeightConsistency(_ nIndex: UInt32) -> Bool {
        blackHeight(nIndex).isConsistent
    }
    
    func blackHeight(_ nIndex: UInt32) -> (isConsistent: Bool, height: Int) {
        guard nIndex != .empty else { return (true, 1) }
        let node = self[nIndex]
        let (leftConsistent, leftHeight) = blackHeight(node.left)
        let (rightConsistent, rightHeight) = blackHeight(node.right)
        return (leftConsistent && rightConsistent && leftHeight == rightHeight, (node.color == .black ? 1 : 0) + leftHeight)
    }
    
    func maxDepth(_ nIndex: UInt32) -> Int {
        guard nIndex != .empty else { return 0 }
        
        let node = self[nIndex]
        
        let leftDepth = self.maxDepth(node.left)
        let rightDepth = self.maxDepth(node.right)
        
        return 1 + max(leftDepth, rightDepth)
    }
    
}
