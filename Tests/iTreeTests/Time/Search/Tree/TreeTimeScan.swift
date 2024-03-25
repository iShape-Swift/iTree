//
//  TreeTimeScan.swift
//  
//
//  Created by Nail Sharipov on 29.02.2024.
//


import iTree

struct TreeTimeScan {
    
    private var tree = RBTree(empty: TimeIntervalValue(value: 0, start: 0, end: 0), capacity: 16)
    
    mutating func insert(item: TimeIntervalValue, stop: Int) {
        var index = tree.root
        var pIndex = UInt32.empty
        var isLeft = false
        
        while index != .empty {
            let node = tree[index]
            pIndex = index
            if node.value.end <= stop {
                index = tree.delete(index: index)
                pIndex = .empty
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
        
        let newIndex = tree.store.getFreeIndex()
        
        var newNode = tree[newIndex]
        newNode.left = .empty
        newNode.right = .empty
        newNode.color = .red
        newNode.value = item
        newNode.parent = pIndex
        tree[newIndex] = newNode
        
        if pIndex == .empty {
            newNode.parent = .empty
            tree.root = newIndex
        } else {
            newNode.parent = pIndex
            
            if isLeft {
                tree[pIndex].left = newIndex
            } else {
                tree[pIndex].right = newIndex
            }
            
            if tree[pIndex].color == .red {
                tree.fixRedBlackPropertiesAfterInsert(nIndex: newIndex, pIndex: pIndex)
            }
        }
    }
    
    mutating func findEqualOrLower(time t: TimeValue) -> Int {
        let index = self.findEqualOrLowerIndex(time: t)
        if index != .empty {
            return tree[index].value.value
        } else {
            return .min
        }
    }

    private mutating func findEqualOrLowerIndex(time t: TimeValue) -> UInt32 {
        var index = tree.root
        var result: UInt32 = .empty
        while index != .empty {
            let node = tree[index]
            if node.value.end <= t.time {
                index = tree.delete(index: index)
            } else {
                if node.value.value == t.value {
                    return index
                } else if node.value.value < t.value {
                    result = index
                    index = node.right
                } else {
                    index = node.left
                }
            }
        }
        
        return result
    }
    
    private mutating func findLowerIndex(time t: TimeValue) -> UInt32 {
        var index = tree.root
        var result: UInt32 = .empty
        while index != .empty {
            let node = tree[index]
            if node.value.end <= t.time {
                index = tree.delete(index: index)
            } else {
                if node.value.value < t.value {
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
            return result
        }
    }
    
}
