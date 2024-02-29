//
//  TreeScan.swift
//
//
//  Created by Nail Sharipov on 28.02.2024.
//

import iFixFloat
import iTree

struct TreeScan {
    
    private var tree = RBTree(empty: IdSegment(index: .max, segment: .init(a: .zero, b: .zero)))
    
    mutating func insert(item: IdSegment, stop: Int32) {
        var index = tree.root
        var pIndex = UInt32.empty
        var isLeft = false
        
        while index != .empty {
            let node = tree[index]
            pIndex = index
            if node.value.segment.b.x <= stop {
                tree.delete(index: index)
                if node.parent != .empty {
                    index = node.parent
                } else {
                    index = tree.root
                    pIndex = .empty
                }
            } else {
                isLeft = item < node.value
                if isLeft {
                    isLeft = true
                    index = node.left
                } else {
                    index = node.right
                }
            }
        }

        var newNode = tree.store.getFree(value: item)

        if pIndex == .empty {
            tree.root = newNode.index
            tree.save(newNode)
        } else {
            newNode.parent = pIndex
            tree.save(newNode)
            
            if isLeft {
                tree[pIndex].left = newNode.index
            } else {
                tree[pIndex].right = newNode.index
            }
            
            if tree[pIndex].color == .red {
                tree.fixRedBlackPropertiesAfterInsert(nIndex: newNode.index, pIndex: pIndex)
            }
        }
    }
    
    mutating func findUnder(point p: Point, stop: Int32) -> IdSegment? {
        var index = tree.root
        var result: UInt32 = .empty
        while index != .empty {
            let node = tree[index]
            if node.value.segment.b.x <= stop {
                tree.delete(index: index)
                if node.parent != .empty {
                    index = node.parent
                } else {
                    index = tree.root
                }
            } else {
                if node.value.segment.isUnder(point: p) {
                    result = index
                    index = node.right
                } else {
                    index = node.left
                }
            }
        }
        
        if result == .empty {
            return nil
        } else {
            return tree[result].value
        }
    }
}
