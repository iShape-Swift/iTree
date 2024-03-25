//
//  NodePool.swift
//  StrTree
//
//  Created by Nail Sharipov on 24.02.2024.
//

public struct NodeStore<T> {

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
        self.buffer.reserveCapacity(capacity)
        self.unused = [UInt32]()
        self.unused.reserveCapacity(capacity)
        self.reserve(length: capacity)
    }

    @inlinable
    public mutating func getFreeIndex() -> UInt32 {
        if unused.isEmpty {
            self.reserve(length: 16)
        }
        return self.unused.removeLast()
    }
    
    @inlinable
    public mutating func putBack(index: UInt32) {
        self.unused.append(index)
    }
    
    @inlinable
    mutating func reserve(length: Int) {
        let n = UInt32(buffer.count)
        let l = UInt32(length)
        for i in 0..<l {
            let node = TreeNode<T>(parent: .empty, left: .empty, right: .empty, color: .red, value: self.empty)
            buffer.append(node)
            unused.append(n + l - i - 1)
        }
    }
    
    @inlinable
    mutating func clearAll() {
        let n = buffer.count
        var i: Int = 1
        while i < n {
            unused[i] = UInt32(n - i)
            i += 1
        }
    }
}
