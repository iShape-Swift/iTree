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
    init(empty: T, array: ArraySlice<T>, extraCapacity: Int = 4) {
        let n = array.count
        
        self.store = NodeStore(empty: empty, capacity: n + extraCapacity)
        self.nilIndex = store.getFreeIndex()
        assert(nilIndex == 0)
        
        guard n != 0 else {
            self.root = .empty
            return
        }
        
        var visited = [Bool](repeating: false, count: n)
        
        let si = array.startIndex
        
        self.root = self.store.getFreeIndex()
        var rootNode = self.store.buffer[Int(self.root)]
        rootNode.color = .black
        let mid = n >> 1
        rootNode.value = array[si + mid]
        visited[mid] = true
        self.store.buffer[Int(self.root)] = rootNode
        
        let log = (n + 1).logTwo - 1
        let s0 = n >> 1
        
        var j = 1
        for i in 1..<log {
            let color: NodeColor = i & 1 == 0 ? .black : .red
            var s = s0
            
            let ni = (1 << (i - 1))
            for _ in 0..<ni {
                let p = ((j - 1) >> 1) + 1
                
                var parent = self.store.buffer[p]
                parent.left = UInt32(j + 1)
                parent.right = UInt32(j + 2)
                self.store.buffer[p] = parent
                
                let lt = s >> i
                let left = self.store.getFreeIndex()
                var leftNode = self.store.buffer[Int(left)]
                leftNode.parent = UInt32(p)
                leftNode.color = color
                leftNode.value = array[si + lt]
                self.store.buffer[Int(left)] = leftNode
                
                s += n
                
                let rt = s >> i
                let right = self.store.getFreeIndex()
                var rightNode = self.store.buffer[Int(right)]
                rightNode.parent = UInt32(p)
                rightNode.color = color
                rightNode.value = array[si + rt]
                self.store.buffer[Int(right)] = rightNode
                
                s += n
                
                j += 2
                
                visited[lt] = true
                visited[rt] = true
            }
        }
        
        for i in 0..<visited.count {
            if !visited[i] {
                self.insert(value: array[si + i])
            }
        }
    }
    
    @inlinable
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
            let lastStackIndex = stack.count - 1
            let s = stack[lastStackIndex]
            
            if s.left != .empty {
                let index = s.left
                stack[lastStackIndex].left = .empty // to skip next time
                
                // go down left
                let node = self[index]
                let left = node.left
                let right = node.right
                stack.append(StackNode(index: index, left: left, right: right))
            } else {
                if s.index != .empty {
                    let index = s.index
                    stack[lastStackIndex].index = .empty // to skip next time
                    
                    // add value
                    list.append(self[index].value)
                }
                
                if s.right != .empty {
                    let index = s.right
                    stack[lastStackIndex].right = .empty // to skip next time
                    
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
    
    @inlinable
    func firstByOrder() -> UInt32 {
        if root != .empty {
            return self.findLeftMinimum(self.root)
        } else {
            return .empty
        }
    }
    
    @inlinable
    func lastByOrder() -> UInt32 {
        if root != .empty {
            return self.findRightMinimum(self.root)
        } else {
            return .empty
        }
    }
    
    @inlinable
    func nextByOrder(index: UInt32) -> UInt32 {
        let this = self[index]
        if this.right != .empty {
            return self.findLeftMinimum(this.right)
        } else {
            // first parent bigger
            var i = this.parent
            while i != .empty {
                if self[i].value > this.value {
                    return i
                } else {
                    i = self[i].parent
                }
            }
            
            // last element
            return .empty
        }
    }
}


extension Int {
    @inlinable
    var logTwo: Int {
        UInt.bitWidth - self.leadingZeroBitCount
    }
}
