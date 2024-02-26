//
//  TreeNode.swift
//  StrTree
//
//  Created by Nail Sharipov on 24.02.2024.
//

enum NodeColor: UInt8 {
    case red
    case black
}

public struct TreeNode<T> {
    
    public let index: UInt32
    public var parent: UInt32
    
    public var left: UInt32
    public var right: UInt32
    
    var color: NodeColor
    
    public var value: T
}

public extension UInt32 {
    static let empty = UInt32.max
}
