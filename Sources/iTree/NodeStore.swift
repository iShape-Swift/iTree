//
//  NodePool.swift
//  StrTree
//
//  Created by Nail Sharipov on 24.02.2024.
//

@usableFromInline
struct NodeStore<T> {

    @usableFromInline
    var buffer: [TreeNode<T>]
    @usableFromInline
    var unused: [UInt32]
    @usableFromInline
    let empty: T

    @inlinable
    init(empty: T, capacity: Int) {
        self.empty = empty
        self.buffer = [TreeNode]()
        self.unused = [UInt32]()
        self.reserve(length: capacity)
    }

    @inlinable
    mutating func getFreeIndex() -> UInt32 {
        if unused.isEmpty {
            self.reserve(length: 16)
        }
        return self.unused.removeLast()
    }
    
    @inlinable
    mutating func getFree() -> TreeNode<T> {
        if unused.isEmpty {
            self.reserve(length: 16)
        }
        let index = Int(self.getFreeIndex())
        
        var node = buffer[index]
        node.left = .empty
        node.right = .empty
        node.parent = .empty
        
        return node
    }
    
    @inlinable
    mutating func putBack(index: UInt32) {
        self.unused.append(index)
    }
    
    @inlinable
    mutating func reserve(length: Int) {
        let n = UInt32(buffer.count)
        let l = UInt32(length)
        for i in 0..<l {
            let index = n + i
            let node = TreeNode<T>(index: index, parent: .empty, left: .empty, right: .empty, color: .red, value: self.empty)
            buffer.append(node)
            unused.append(n + l - i - 1)
        }
    }
}
