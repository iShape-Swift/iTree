//
//  RBTree.swift
//  StrTree
//
//  Created by Nail Sharipov on 26.02.2024.
//

public struct RBTree<T: Comparable> {
    
    public var store: NodeStore<T>
    
    @usableFromInline
    let nilIndex: UInt32
    
    public var root: UInt32
    
    @inlinable
    public subscript(index: UInt32) -> TreeNode<T> {
        get {
            store.buffer[Int(index)]
        }
        set {
            store.buffer[Int(index)] = newValue
        }
    }
    
    @inlinable
    public mutating func clearAll() {
        guard root != .empty else {
            return
        }
        store.putBack(index: root)
        root = .empty
        
        var n = 1
        repeat {
            let i0 = store.unused.count - n
            n = 0
            for i in i0..<store.unused.count {
                let index = store.unused[i]
                let node = self[index]
                if node.left != .empty {
                    store.putBack(index: node.left)
                    n += 1
                }
                if node.right != .empty {
                    store.putBack(index: node.right)
                    n += 1
                }
            }
        } while n > 0
    }
    
    @inlinable
    func isBlack(_ index: UInt32) -> Bool {
        index == .empty || index != .empty && store.buffer[Int(index)].color == .black
    }
    
    @inlinable
    mutating func createNilNode(parent: UInt32) {
        var node = store.buffer[Int(self.nilIndex)]
        node.parent = parent
        node.left = .empty
        node.right = .empty
        node.color = .red
    }
    
#if DEBUG
    @inlinable
    public init(empty: T, capacity: Int) {
        self.store = NodeStore(empty: empty, capacity: capacity)
        self.nilIndex = store.getFreeIndex()
        assert(nilIndex == 0)
        self.root = .empty
    }
#else
    @inlinable
    public init(empty: T, capacity: Int) {
        self.store = NodeStore(empty: empty, capacity: capacity)
        self.nilIndex = store.getFreeIndex()
        self.root = .empty
    }
#endif
    
    @inlinable
    mutating func rotateRight(_ index: UInt32) {
        var n = self[index]
        let p = n.parent
        
        let ltIndex = n.left
        let ltRight = self[ltIndex].right
        
        if ltRight != .empty {
            n.left = ltRight
            self[ltRight].parent = index
        } else {
            n.left = .empty
        }
        
        self[ltIndex].right = index
        n.parent = ltIndex
        
        self[index] = n
        
        self.replaceParentsChild(p, oldChild: index, newChild: ltIndex)
    }
    
    @inlinable
    mutating func rotateLeft(_ index: UInt32) {
        var n = self[index]
        let p = n.parent
        
        let rtIndex = n.right
        let r = self[rtIndex]
        
        if r.left != .empty {
            n.right = r.left
            self[r.left].parent = index
        } else {
            n.right = .empty
        }
        
        self[rtIndex].left = index
        n.parent = rtIndex
        
        self[index] = n
        
        self.replaceParentsChild(p, oldChild: index, newChild: rtIndex)
    }
    
    @inlinable
    mutating func replaceParentsChild(_ parent: UInt32, oldChild: UInt32, newChild: UInt32) {
        self[newChild].parent = parent
        guard parent != .empty else {
            root = newChild
            return
        }
        
        var p = self[parent]
        assert(p.left == oldChild || p.right == oldChild, "Node is not a child of its parent")
        
        if p.left == oldChild {
            p.left = newChild
        } else {
            p.right = newChild
        }
        
        self[parent] = p
    }
    
    @inlinable
    mutating func replaceParentsChild(_ parent: UInt32, oldChild: UInt32) {
        var p = self[parent]
        assert(p.left == oldChild || p.right == oldChild, "Node is not a child of its parent")
        
        if p.left == oldChild {
            p.left = .empty
        } else {
            p.right = .empty
        }
        
        self[parent] = p
    }
    
    @inlinable
    public mutating func insertIfNotExist(value: T) -> Bool {
        guard self.root != .empty else {
            self.insertRoot(value: value)
            return true
        }
        
        var index = root
        var pIndex = root
        var isLeft = false
        
        repeat {
            let node = self[index]
            pIndex = index
            guard node.value != value else {
                return false
            }
            
            isLeft = value < node.value
            if isLeft {
                isLeft = true
                index = node.left
            } else {
                index = node.right
            }
        } while index != .empty
        
        _ = self.insert(value: value, pIndex: pIndex, isLeft: isLeft)
        
        return true
    }

    @inlinable
    public mutating func insert(value: T) {
        guard self.root != .empty else {
            self.insertRoot(value: value)
            return
        }
        
        var index = root
        var pIndex = root
        var isLeft = false
        
        repeat {
            let node = self[index]
            pIndex = index
            assert(node.value != value)
            
            isLeft = value < node.value
            if isLeft {
                isLeft = true
                index = node.left
            } else {
                index = node.right
            }
        } while index != .empty
        
        _ = self.insert(value: value, pIndex: pIndex, isLeft: isLeft)
    }
    
    @inlinable
    public mutating func insertRoot(value: T) {
        let newIndex = self.store.getFreeIndex()
        var newNode = self[newIndex]
        newNode.parent = .empty
        newNode.left = .empty
        newNode.right = .empty
        newNode.color = .black
        newNode.value = value
        self[newIndex] = newNode
        self.root = newIndex
    }
    
    @inlinable
    public mutating func insert(value: T, pIndex: UInt32, isLeft: Bool) -> UInt32 {
        let newIndex = self.store.getFreeIndex()
        var newNode = self[newIndex]
        newNode.parent = pIndex
        newNode.left = .empty
        newNode.right = .empty
        newNode.color = .red
        newNode.value = value
        self[newIndex] = newNode
        
        if isLeft {
            self[pIndex].left = newIndex
        } else {
            self[pIndex].right = newIndex
        }
        
        if self[pIndex].color == .red {
            fixRedBlackPropertiesAfterInsert(nIndex: newIndex, pIndex: pIndex)
        }
        
        return newIndex
    }
    
    
    @inlinable
    public mutating func fixRedBlackPropertiesAfterInsert(nIndex: UInt32, pIndex: UInt32) {
        // parent is red!
        var pIndex = pIndex
        let parent = self[pIndex]
        // Case 2:
        // Not having a grandparent means that parent is the root. If we enforce black roots
        // (rule 2), grandparent will never be null, and the following if-then block can be
        // removed.
        let gIndex = parent.parent
        guard gIndex != .empty else {
            // As this method is only called on red nodes (either on newly inserted ones - or -
            // recursively on red grandparents), all we have to do is to recolor the root black.
            self[pIndex].color = .black
            return
        }
        
        // Case 3: Uncle is red -> recolor parent, grandparent and uncle
        let uIndex = self.getUncle(pIndex: pIndex)
        let grandparent = self[gIndex]
        if uIndex != .empty && self[uIndex].color == .red {
            self[pIndex].color = .black
            self[gIndex].color = .red
            self[uIndex].color = .black
            
            // Call recursively for grandparent, which is now red.
            // It might be root or have a red parent, in which case we need to fix more...
            let ggIndex = grandparent.parent
            if ggIndex != .empty, self[ggIndex].color == .red {
                self.fixRedBlackPropertiesAfterInsert(nIndex: gIndex, pIndex: ggIndex)
            }
        } else if pIndex == grandparent.left {
            // Parent is left child of grandparent
            // Case 4a: Uncle is black and node is left->right "inner child" of its grandparent
            if nIndex == parent.right {
                rotateLeft(pIndex)
                
                // Let "parent" point to the new root node of the rotated sub-tree.
                // It will be recolored in the next step, which we're going to fall-through to.
                pIndex = nIndex
            }
            
            // Case 5a: Uncle is black and node is left->left "outer child" of its grandparent
            rotateRight(gIndex)
            
            // Recolor original parent and grandparent
            self[pIndex].color = .black
            self[gIndex].color = .red
        } else {
            // Parent is right child of grandparent
            // Case 4b: Uncle is black and node is right->left "inner child" of its grandparent
            if nIndex == parent.left {
                rotateRight(pIndex)
                
                // Let "parent" point to the new root node of the rotated sub-tree.
                // It will be recolored in the next step, which we're going to fall-through to.
                pIndex = nIndex
            }
            
            // Case 5b: Uncle is black and node is right->right "outer child" of its grandparent
            rotateLeft(gIndex)
            
            // Recolor original parent and grandparent
            self[pIndex].color = .black
            self[gIndex].color = .red
        }
    }
    
    @inlinable
    func getUncle(pIndex: UInt32) -> UInt32 {
        let parent = self[pIndex]
        guard parent.parent != .empty else {
            return .empty
        }
        
        let grandparent = self[parent.parent]
        
        assert(grandparent.left == pIndex || grandparent.right == pIndex, "Parent is not a child of its grandparent")
        
        if grandparent.left == pIndex {
            return grandparent.right
        } else {
            return grandparent.left
        }
    }
    
    @inlinable
    public mutating func delete(value: T) {
        var index = root
        // Find the node to be deleted
        while index != .empty {
            let node = self[index]
            if value == node.value {
                break
            } else if value < node.value {
                index = node.left
            } else {
                index = node.right
            }
        }
        
        guard index != .empty else {
            assertionFailure("value is not found")
            return
        }
        
        _ = self.delete(index: index)
    }
    
    @inlinable
    public mutating func delete(index: UInt32) -> UInt32 {
        let movedUpNode: UInt32
        let deletedNodeColor: NodeColor
        
        let node = self[index]
        
        let isRoot = index == root
        let isSingle = node.left == .empty || node.right == .empty
        
        // Node has zero or one child
        if isSingle {
            deletedNodeColor = node.color
            movedUpNode = deleteNodeWithZeroOrOneChild(index)
        } else {
            let successorIndex = findLeftMinimum(node.right)
            let successor = self[successorIndex]
            deletedNodeColor = successor.color
            
            self[index].value = successor.value
            
            movedUpNode = deleteNodeWithZeroOrOneChild(successorIndex)
        }
        
        guard movedUpNode != .empty, deletedNodeColor == .black else {
            return isSingle ? self.parent(index: index) : (isRoot ? root : index)
        }
        
        fixRedBlackPropertiesAfterDelete(movedUpNode)
        
        if movedUpNode == self.nilIndex {
            let pIndex = self[movedUpNode].parent
            
            if pIndex != .empty {
                self.replaceParentsChild(pIndex, oldChild: movedUpNode)
            }
        }
        
        return isSingle ? self.parent(index: index) : (isRoot ? root : index)
    }
    
    @inlinable
    func parent(index: UInt32) -> UInt32 {
        let parent = self[index].parent
        return parent == .empty ? root : parent
    }
    
    @inlinable
    mutating func deleteNodeWithZeroOrOneChild(_ nIndex: UInt32) -> UInt32 {
        self.store.putBack(index: nIndex)
        let node = self[nIndex]
        if node.left != .empty {
            // Node has ONLY a left child --> replace by its left child
            self.replaceParentsChild(node.parent, oldChild: nIndex, newChild: node.left)
            return node.left // moved-up node
        } else if node.right != .empty {
            // Node has ONLY a right child --> replace by its right child
            self.replaceParentsChild(node.parent, oldChild: nIndex, newChild: node.right)
            return node.right // moved-up node
        } else {
            // Node has no children -->
            // * node is red --> just remove it
            // * node is black --> replace it by a temporary NIL node (needed to fix the R-B rules)
            
            if node.parent != .empty {
                if node.color == .black {
                    self.createNilNode(parent: node.parent)
                    replaceParentsChild(node.parent, oldChild: nIndex, newChild: self.nilIndex)
                    return self.nilIndex
                } else {
                    replaceParentsChild(node.parent, oldChild: nIndex)
                    return .empty
                }
            } else {
                root = .empty
                return .empty
            }
        }
    }
    
    @inlinable
    mutating func fixRedBlackPropertiesAfterDelete(_ nIndex: UInt32) {
        // Case 1: Examined node is root, end of recursion
        guard nIndex != root else {
            // do not color root to black
            return
        }
        
        var sIndex = getSibling(nIndex)
        
        // Case 2: Red sibling
        if self[sIndex].color == .red {
            handleRedSibling(nIndex, sIndex)
            sIndex = getSibling(nIndex) // Get new sibling for fall-through to cases 3-6
        }
        
        let sibling = self[sIndex]
        
        // Cases 3+4: Black sibling with two black children
        if isBlack(sibling.left) && isBlack(sibling.right) {
            self[sIndex].color = .red
            let pIndex = self[nIndex].parent
            
            // Case 3: Black sibling with two black children + red parent
            if self[pIndex].color == .red {
                self[pIndex].color = .black
            } else {
                // Case 4: Black sibling with two black children + black parent
                fixRedBlackPropertiesAfterDelete(pIndex)
            }
        } else {
            // Case 5+6: Black sibling with at least one red child
            handleBlackSiblingWithAtLeastOneRedChild(nIndex, sIndex)
        }
    }
    
    @inlinable
    mutating func handleBlackSiblingWithAtLeastOneRedChild(_ nIndex: UInt32, _ sIndex: UInt32) {
        var sIndex = sIndex
        let pIndex = self[nIndex].parent
        var sibling = self[sIndex]
        let nodeIsLeftChild = nIndex == self[pIndex].left
        
        // Case 5: Black sibling with at least one red child + "outer nephew" is black
        // --> Recolor sibling and its child, and rotate around sibling
        if nodeIsLeftChild && isBlack(sibling.right) {
            if sibling.left != .empty {
                self[sibling.left].color = .black
            }
            self[sIndex].color = .red
            rotateRight(sIndex)
            sIndex = self[pIndex].right
            sibling = self[sIndex]
        } else if !nodeIsLeftChild && isBlack(sibling.left) {
            if sibling.right != .empty {
                self[sibling.right].color = .black
            }
            self[sIndex].color = .red
            rotateLeft(sIndex)
            sIndex = self[pIndex].left
            sibling = self[sIndex]
        }
        
        // Fall-through to case 6...
        
        // Case 6: Black sibling with at least one red child + "outer nephew" is red
        // --> Recolor sibling + parent + sibling's child, and rotate around parent
        self[sIndex].color = self[pIndex].color
        self[pIndex].color = .black
        if nodeIsLeftChild {
            if sibling.right != .empty {
                self[sibling.right].color = .black
            }
            rotateLeft(pIndex)
        } else {
            if sibling.left != .empty {
                self[sibling.left].color = .black
            }
            rotateRight(pIndex)
        }
    }
    
    @inlinable
    mutating func handleRedSibling(_ nIndex: UInt32, _ sIndex: UInt32) {
        // Recolor...
        
        self[sIndex].color = .black
        let pIndex = self[nIndex].parent
        
        self[pIndex].color = .red
        
        // ... and rotate
        if nIndex == self[pIndex].left {
            rotateLeft(pIndex)
        } else {
            rotateRight(pIndex)
        }
    }
    
    @inlinable
    func getSibling(_ nIndex: UInt32) -> UInt32 {
        let pIndex = self[nIndex].parent
        let parent = self[pIndex]
        assert(nIndex == parent.left || nIndex == parent.right)
        if nIndex == parent.left {
            return parent.right
        } else {
            return parent.left
        }
    }
    
    @inlinable
    func findLeftMinimum(_ nIndex: UInt32) -> UInt32 {
        var i = nIndex
        while self[i].left != .empty {
            i = self[i].left
        }
        
        return i
    }
    
    @inlinable
    public func find(value: T) -> T? {
        var index = root
        
        while index != .empty {
            let node = self[index]
            if node.value == value {
                return node.value
            } else if value < node.value {
                index = node.left
            } else {
                index = node.right
            }
        }
        
        return nil
    }
    
    @inlinable
    public func findIndex(value: T) -> UInt32 {
        var index = root
        
        while index != .empty {
            let node = self[index]
            if node.value == value {
                return index
            } else if value < node.value {
                index = node.left
            } else {
                index = node.right
            }
        }
        
        return .empty
    }
    
    @inlinable
    public func height() -> Int {
        guard self.root != .empty else { return 0 }
        var node = self[self.root]
        var height = 1
        while node.left != .empty {
            node = self[node.left]
            if node.color == .black {
                height += 1
            }
        }
        
        return height << 1
    }
}
