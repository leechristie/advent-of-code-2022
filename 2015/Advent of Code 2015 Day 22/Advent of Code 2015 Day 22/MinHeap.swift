//
//  MinHeap.swift
//  Advent of Code 2015 Day 22
//
//  Created by 0x1ac on 2023-05-06.
//

import Foundation

struct MinHeap<T: Hashable>: CustomStringConvertible {
    
    var budget = 100
    
    private struct HeapNode {
        
        let element: T
        
        var key: Int
        var index: Int
        
    }
    
    private var heap: [HeapNode] = []
    private var lookup: [T:HeapNode] = [:]
    
    private func HEAP_STRING() -> String {
        var rv = "["
        for node in heap {
            if rv.count > 1 {
                rv += ", "
            }
            rv += "(K=\(node.key), E=\(node.element), I=\(node.index))"
        }
        return rv + "]"
    }
    
    mutating private func append(node element: T, withKey key: Int) {
        let index: Int = heap.count
        let node: HeapNode = HeapNode(element: element, key: key, index: index)
        lookup[element] = node
        heap.append(node)
    }
    
    mutating private func swap(nodeAtIndex a: Int, withNodeAtIndex b: Int) {
        if a == b {
            fatalError("can't swap at same index")
        }
        if a < 0 || a >= heap.count {
            fatalError("\(a) is invalid index")
        }
        if b < 0 || b >= heap.count {
            fatalError("\(b) is invalid index")
        }
        budget -= 1
        if budget < 0 {
            fatalError("too many swaps!")
        }
        let temp = heap[a]
        heap[a] = heap[b]
        heap[b] = temp
        heap[a].index = a
        heap[b].index = b
    }
    
    mutating func add(element: T, withKey key: Int) {
        if let _ = lookup[element] {
            fatalError("duplicate element \(element)")
        }
        append(node: element, withKey: key);
        var index: Int = heap.count - 1
        var parentIndex: Int = (index - 1) / 2
        var parentKey: Int? = (parentIndex >= 0) ? heap[parentIndex].key : nil
        while let unwrappedParentKey = parentKey, key < unwrappedParentKey {
            swap(nodeAtIndex: index, withNodeAtIndex: parentIndex)
            index = parentIndex
            parentIndex = (index - 1) / 2
            parentKey = (parentIndex >= 0) ? heap[parentIndex].key : nil
        }
    }
    
    mutating func decreaseKey(ofElement element: T, toNewKey key: Int) {
        
        if lookup[element] == nil {
            fatalError("element \(element) not found");
        }
        
        let oldKey: Int = lookup[element]!.key
        
        if key >= oldKey {
            fatalError("can only decrease key, current key = \(oldKey), new key = \(key), which is not smaller");
        }
        
        lookup[element]!.key = key
        
        var index: Int = lookup[element]!.index
        var parentIndex: Int = (index - 1) / 2
        var parentKey: Int? = (parentIndex < 0) ? nil : heap[parentIndex].key
        
        while parentKey != nil && key < parentKey! {
            
            // check?
            if index == parentIndex {
                return
            }
            
            swap(nodeAtIndex: index, withNodeAtIndex: parentIndex)
            index = parentIndex
            parentIndex = (index - 1) / 2
            assert(parentIndex >= 0)
            parentKey = heap[parentIndex].key
        }
        
    }
    
    mutating func deleteMinimum() -> T? {
        if heap.isEmpty {
            return nil
        }
        let rootElement: T
        if heap.count == 1 {
            rootElement = heap.remove(at: 0).element
        } else {
            rootElement = heap[0].element
            swap(nodeAtIndex: 0, withNodeAtIndex: heap.count - 1)
            _ = heap.popLast()
            repairHeap(atIndex: 0);
        }
        lookup.removeValue(forKey: rootElement)
        return rootElement;
    }
    
    mutating private func repairHeap(atIndex index: Int) {
        let leftIndex: Int = 2 * index + 1
        let rightIndex: Int = leftIndex + 1
        let key: Int = heap[index].key
        let leftKey = (leftIndex < heap.count) ? heap[leftIndex].key : nil
        let rightKey = (rightIndex < heap.count) ? heap[rightIndex].key : nil
        var smallestIndex: Int = index
        var smallestKey: Int = key
        if let leftKey, leftKey < smallestKey {
            smallestKey = leftKey
            smallestIndex = leftIndex
        }
        if let rightKey, rightKey < smallestKey {
            smallestIndex = rightIndex
        }
        if smallestIndex != index {
            swap(nodeAtIndex: index, withNodeAtIndex: smallestIndex)
            repairHeap(atIndex: smallestIndex)
        }
    }
    
    var description: String {
        var rv = "{"
        for node in heap {
            if rv.count > 1 {
                rv += ", "
            }
            rv += "\(node.key)"
            rv += ":";
            rv += "\(node.element)"
        }
        return rv + "}"
    }
    
}
