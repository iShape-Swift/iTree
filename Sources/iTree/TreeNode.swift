//
//  TreeNode.swift
//  StrTree
//
//  Created by Nail Sharipov on 24.02.2024.
//

public enum NodeColor: UInt8 {
    case red
    case black
}

public struct TreeNode<T> {

    public let index: UInt32
    public var parent: UInt32
    
    public var left: UInt32
    public var right: UInt32

    public var color: NodeColor
    
    public var value: T
    
    @usableFromInline
    init(index: UInt32, parent: UInt32, left: UInt32, right: UInt32, color: NodeColor, value: T) {
        self.index = index
        self.parent = parent
        self.left = left
        self.right = right
        self.color = color
        self.value = value
    }
    
}

public extension UInt32 {
    static let empty = UInt32.max
}
