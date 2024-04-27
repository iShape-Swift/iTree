//
//  Array.swift
//
//
//  Created by Nail Sharipov on 27.04.2024.
//


public struct StackNode {
    
    @usableFromInline
    var index: UInt32
    @usableFromInline
    var left: UInt32
    @usableFromInline
    var right: UInt32
    
    @inlinable
    init(index: UInt32, left: UInt32, right: UInt32) {
        self.index = index
        self.left = left
        self.right = right
    }
}


public extension RBTree {
    
    @inlinable
    init(empty: T, array: [T], extraCapacity: Int = 4) {
        self.store = NodeStore(empty: empty, capacity: array.count + extraCapacity)
        self.nilIndex = store.getFreeIndex()
        assert(nilIndex == 0)
        
        guard !array.isEmpty else {
            self.root = .empty
            return
        }
        
        self.root = self.store.getFreeIndex()
        var rootNode = self.store.buffer[Int(self.root)]
        rootNode.color = .black
        rootNode.value = array[0]
        self.store.buffer[Int(self.root)] = rootNode
        
        var n = array.count
        let log = n.logTwo
        
        var j = 1
        for i in 1..<log {
            let color: NodeColor = i & 1 == 0 ? .black : .red
            let st = n >> i
            var s = st >> 1
            
            while s < n {
                let pi = (j - 1) >> 1
                if j + 1 < n {
                    var parent = self.store.buffer[pi]
                    parent.left = UInt32(j)
                    parent.right = UInt32(j + 1)
                    self.store.buffer[pi] = parent
                    
                    let left = self.store.getFreeIndex()
                    var leftNode = self.store.buffer[Int(left)]
                    leftNode.color = color
                    leftNode.value = array[s]
                    self.store.buffer[Int(left)] = leftNode
                    
                    s += st
                    
                    let right = self.store.getFreeIndex()
                    var rightNode = self.store.buffer[Int(right)]
                    rightNode.color = color
                    rightNode.value = array[s]
                    self.store.buffer[Int(right)] = rightNode
                    
                    s += st
                    
                    j += 2
                } else {
                    if j < n {
                        var parent = self.store.buffer[pi]
                        parent.left = UInt32(j)
                        self.store.buffer[pi] = parent
                        
                        let left = self.store.getFreeIndex()
                        var leftNode = self.store.buffer[Int(left)]
                        leftNode.color = color
                        leftNode.value = array[s]
                        self.store.buffer[Int(left)] = leftNode
                    }
                    break
                }
            }
        }
    }
    
    
    func orderedList() -> [T] {
        if self.root == .empty {
            return []
        }
        
        let height = self.height()
        var list = [T]()
        list.reserveCapacity(1 << height)
        var stack = [StackNode]()
        stack.reserveCapacity(height)
        self.fillOrderedListWithStack(list: &list, stack: &stack)
        
        return list
    }
    
    @inlinable
    func fillOrderedList(list: inout [T]) {
        let height = self.height()
        var stack = [StackNode]()
        stack.reserveCapacity(height)
        self.fillOrderedListWithStack(list: &list, stack: &stack)
    }
    
    @inlinable
    func fillOrderedListWithStack(list: inout [T], stack: inout [StackNode]) {
        list.removeAll(keepingCapacity: true)
        stack.removeAll(keepingCapacity: true)
        
        let rootNode = self[self.root]
        stack.append(StackNode(index: self.root, left: rootNode.left, right: rootNode.right))
        
        while !stack.isEmpty {
            let last_stack_index = stack.count - 1
            var s = stack[last_stack_index]
            
            if s.left != .empty {
                let index = s.left
                s.left = .empty // to skip next time
                
                // go down left
                let node = self[index]
                let left = node.left
                let right = node.right
                stack.append(StackNode(index: index, left: left, right: right))
            } else {
                if s.index != .empty {
                    let index = s.index
                    s.index = .empty // to skip next time
                    
                    // add value
                    list.append(self[index].value)
                }
                
                if s.right != .empty {
                    let index = s.right
                    s.right = .empty // to skip next time
                    
                    // go down right
                    let node = self[index]
                    let left = node.left
                    let right = node.right
                    stack.append(StackNode(index: index, left: left, right: right))
                } else {
                    // go up
                    _ = stack.removeLast()
                }
            }
        }
    }
}


extension Int {
    @inlinable
    var logTwo: Int {
        UInt.bitWidth - self.leadingZeroBitCount
    }
}
