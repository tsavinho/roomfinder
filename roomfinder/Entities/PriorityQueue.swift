//
//  PriorityQueue.swift
//  roomfinder
//
//  Created by Pascal Köchli while using Chat-GPT on 12.02.2024.
//

import Foundation

struct PriorityQueue<Element> {
    private var elements: [Element] = []
    private let sorter: (Element, Element) -> Bool

    init(sort: @escaping (Element, Element) -> Bool) {
        self.sorter = sort
    }

    var isEmpty: Bool {
        return elements.isEmpty
    }

    mutating func enqueue(_ element: Element) {
        elements.append(element)
        upHeapify(elements.count - 1)
    }

    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else { return nil }
        elements.swapAt(0, elements.count - 1)
        let dequeued = elements.removeLast()
        downHeapify(0)
        return dequeued
    }

    private func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }

    private func leftChildIndex(of index: Int) -> Int {
        return 2 * index + 1
    }

    private func rightChildIndex(of index: Int) -> Int {
        return 2 * index + 2
    }

    private mutating func upHeapify(_ index: Int) {
        let parent = parentIndex(of: index)
        if index > 0 && sorter(elements[index], elements[parent]) {
            elements.swapAt(index, parent)
            upHeapify(parent)
        }
    }

    private mutating func downHeapify(_ index: Int) {
        let left = leftChildIndex(of: index)
        let right = rightChildIndex(of: index)
        var highest = index
        if left < elements.count && sorter(elements[left], elements[highest]) {
            highest = left
        }
        if right < elements.count && sorter(elements[right], elements[highest]) {
            highest = right
        }
        if highest != index {
            elements.swapAt(index, highest)
            downHeapify(highest)
        }
    }
}
