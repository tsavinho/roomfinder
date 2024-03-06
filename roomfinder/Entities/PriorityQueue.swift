//
//  PriorityQueue.swift
//  roomfinder
//
//  Created by Pascal Köchli while using Chat-GPT on 12.02.2024.
//

import Foundation

// Defines a generic PriorityQueue structure that can handle elements of any type.
struct PriorityQueue<Element> {
    // Private array to store the elements of the queue in heap order.
    private var elements: [Element] = []
    // Closure that defines the sorting criteria between elements.
    private let sorter: (Element, Element) -> Bool

    // Initializes the priority queue with a sorting function.
    init(sort: @escaping (Element, Element) -> Bool) {
        self.sorter = sort
    }

    // Computed property to check if the queue is empty.
    var isEmpty: Bool {
        return elements.isEmpty
    }

    // Adds a new element to the queue and maintains heap order.
    mutating func enqueue(_ element: Element) {
        elements.append(element) // Adds the element to the end.
        upHeapify(elements.count - 1) // Reorders the heap upwards.
    }

    // Removes and returns the element with the highest priority.
    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else { return nil } // Checks if the queue is not empty.
        elements.swapAt(0, elements.count - 1) // Swaps the first element with the last.
        let dequeued = elements.removeLast() // Removes the last element (previously the first).
        downHeapify(0) // Reorders the heap downwards.
        return dequeued // Returns the removed element.
    }

    // Calculates the index of the parent of a given node.
    private func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }

    // Calculates the index of the left child of a given node.
    private func leftChildIndex(of index: Int) -> Int {
        return 2 * index + 1
    }

    // Calculates the index of the right child of a given node.
    private func rightChildIndex(of index: Int) -> Int {
        return 2 * index + 2
    }

    // Reorders the heap upwards from a given index to maintain heap property.
    private mutating func upHeapify(_ index: Int) {
        let parent = parentIndex(of: index)
        if index > 0 && sorter(elements[index], elements[parent]) {
            elements.swapAt(index, parent) // Swaps if current is higher priority than parent.
            upHeapify(parent) // Recursively adjusts from the parent's position.
        }
    }

    // Reorders the heap downwards from a given index to maintain heap property.
    private mutating func downHeapify(_ index: Int) {
        let left = leftChildIndex(of: index)
        let right = rightChildIndex(of: index)
        var highest = index
        if left < elements.count && sorter(elements[left], elements[highest]) {
            highest = left // Left child has higher priority.
        }
        if right < elements.count && sorter(elements[right], elements[highest]) {
            highest = right // Right child has higher priority.
        }
        if highest != index {
            elements.swapAt(index, highest) // Swaps if child is higher priority than current.
            downHeapify(highest) // Recursively adjusts from the child's position.
        }
    }
}
