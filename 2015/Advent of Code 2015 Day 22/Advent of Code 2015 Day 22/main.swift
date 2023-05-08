//
//  main.swift
//  Advent of Code 2015 Day 22
//
//  Created by 0x1ac on 2023-05-01.
//

import Foundation

print("init")
var heap = MinHeap<String>()

heap.add(element: "foo", withKey: 300)
heap.add(element: "bar", withKey: 100)
heap.add(element: "baz", withKey: 200)
print(heap)
heap.decreaseKey(ofElement: "foo", toNewKey: 50) // decreaseKey broken
print(heap)
print(heap.deleteMinimum() as Any)
print(heap.deleteMinimum() as Any)
print(heap.deleteMinimum() as Any)
print(heap.deleteMinimum() as Any)
print()
