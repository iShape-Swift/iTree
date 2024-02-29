//
//  TreeTimeScan.swift
//  
//
//  Created by Nail Sharipov on 29.02.2024.
//


import iTree

struct TreeTimeScan {
    
    private var tree = RBTree(empty: RangeTimeValue(value: 0, start: 0, end: 0))
    
    mutating func insert(item: RangeTimeValue, stop: Int) {
        var index = tree.root
        var pIndex = UInt32.empty
        var isLeft = false
        
        while index != .empty {
            let node = tree[index]
            pIndex = index
            if node.value.end <= stop {
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
    
    mutating func findEqualOrLower(time t: TimeValue) -> Int {
        var index = tree.root
        var result: UInt32 = .empty
        while index != .empty {
            let node = tree[index]
            if node.value.end <= t.time {
                tree.delete(index: index)
                if node.parent != .empty {
                    index = node.parent
                } else {
                    index = tree.root
                }
            } else {
                if node.value.value == t.value {
                    return node.value.value
                } else if node.value.value < t.value {
                    result = index
                    index = node.right
                } else {
                    index = node.left
                }
            }
        }
        
        if result == .empty {
            return .min
        } else {
            return tree[result].value.value
        }
    }
}
